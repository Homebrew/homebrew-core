class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.11.0.tar.gz"
  sha256 "134ae87340eac42f1650a730e5eb66876e8079908429fb49a83c4eb6b35992cb"

  bottle do
    cellar :any_skip_relocation
    sha256 "f2e309b3cb8eef8d1cc2605cab63fc98f2ad19894bf5ca1e5589e9c36d67a0b0" => :mojave
    sha256 "7e5e0c5273ca35258399bdf7385ad1c84099b63d51910c3d6b0cf01ba97224a8" => :high_sierra
    sha256 "5704f4dffeee36fb11c2ec3f3d22d1f641f9f465f57700401cbe95b0762398ec" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/open-policy-agent/opa").install buildpath.children

    cd "src/github.com/open-policy-agent/opa" do
      system "go", "build", "-o", bin/"opa", "-installsuffix", "static",
                   "-ldflags",
                   "-X github.com/open-policy-agent/opa/version.Version=#{version}"
      prefix.install_metafiles
    end
  end

  test do
    output = shell_output("#{bin}/opa eval -f pretty '[x, 2] = [1, y]' 2>&1")
    assert_equal "+---+---+\n| x | y |\n+---+---+\n| 1 | 2 |\n+---+---+\n", output
    assert_match "Version: #{version}", shell_output("#{bin}/opa version 2>&1")
  end
end

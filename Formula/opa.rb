class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.12.1.tar.gz"
  sha256 "b0c8b6883bc1ca8eb34499d9338d3afc5ce6c53d63607555e14f2d6bfaa28597"

  bottle do
    cellar :any_skip_relocation
    sha256 "dcaa4d1a4524b1d6dbed57f5bde68e997233adbc341c86a6538f105a0cd27a64" => :mojave
    sha256 "e9c4c5a53156e6281b5ce0f8b6eb1af93b4ec07a50fac42ef406ad2e854916fe" => :high_sierra
    sha256 "6e3bce00df3ed4892d34a3b871083c110fa3c70fe78957a85b00ccfc26ba91aa" => :sierra
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

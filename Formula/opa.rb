class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.11.0.tar.gz"
  sha256 "134ae87340eac42f1650a730e5eb66876e8079908429fb49a83c4eb6b35992cb"

  bottle do
    cellar :any_skip_relocation
    sha256 "e7b789ac14d7a3d9527fe72bfff7f0f165af22f64a931ffdd739f1135995f0c1" => :mojave
    sha256 "59bf52a8f446db89cf85540c855cbdef4acc7ae70096737ce81e7c04828c8655" => :high_sierra
    sha256 "30f705efa6a9a0d9d08fb6228d4f1e28e628ffe89844252e6a9899f3b015dc05" => :sierra
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

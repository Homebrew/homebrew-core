class Gopls < Formula
  desc "Language server for the Go language"
  homepage "https://github.com/golang/tools/tree/master/gopls"
  url "https://github.com/golang/tools/archive/gopls/v0.6.4.tar.gz"
  sha256 "4e90f083d3659a0640538e3e4b047b8474de5c9a69525e535b840281734fc3a5"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/(?:gopls%2F)?v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "4e12db94784f39c95219ff1c67bd7d5bf4e2e95481812abf543a3040a10afa03" => :big_sur
    sha256 "ff2008f39e9a90b5c59ae656a29af873b8be65e563fb8c402e056b00a7452e88" => :arm64_big_sur
    sha256 "8106fde32188da8644e1c08f4020b45a452df1ef3428d54d428bf9cb7fad8483" => :catalina
    sha256 "ca0d3857bcf31c8b37fa4fb6b547f259341f25cdb8107720f1e1c7c640ab7d8e" => :mojave
  end

  depends_on "go" => :build

  def install
    cd "gopls" do
      system "go", "build", *std_go_args
    end
  end

  test do
    output = shell_output("#{bin}/gopls api-json")
    output = JSON.parse(output)

    assert_equal "gopls.generate", output["Commands"][0]["Command"]
    assert_equal "buildFlags", output["Options"]["User"][0]["Name"]
  end
end

class Gopls < Formula
  desc "Language server for the Go language"
  homepage "https://github.com/golang/tools/tree/master/gopls"
  url "https://github.com/golang/tools/archive/gopls/v0.7.3.tar.gz"
  sha256 "8a50c76328469602d0e26fcd145d3ce7e3076684024e55d84c80db570ec94405"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{(?:content|href)=.*?/tag/(?:gopls%2F)?v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d85a6aaf9fdee5fb11643df086809e83694cdb11c951c6ae5bd7d8c7fd82792b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "13d75c3c170341c89c5d4f20ff2529142930aa8b4b8b2ec15e68aa3ad9d686ad"
    sha256 cellar: :any_skip_relocation, monterey:       "ac75c4f3425451b6b1b242820a155a1e8fda413d1d1785b4fcd30aa6579bf72a"
    sha256 cellar: :any_skip_relocation, big_sur:        "ab84294c3148d2f0ebb6d3e5d06673e19303041f9c5d8f3866e4c06d1167f9f7"
    sha256 cellar: :any_skip_relocation, catalina:       "8379dd0c00228c617f6dac6de60feb0a2962d1bfffd06d9f03c4ef66e191cce9"
    sha256 cellar: :any_skip_relocation, mojave:         "e1b4b5f5688554660711ebb64f2d98fda1ffd9a1f6eee86a14e6472eaea53101"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02392419baea5991aa5a139c1f6f59f8609ea4095495b0a026deea6aba65a40f"
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

    assert_equal "gopls.add_dependency", output["Commands"][0]["Command"]
    assert_equal "buildFlags", output["Options"]["User"][0]["Name"]
  end
end

class Gopls < Formula
  desc "Language server for the Go language"
  homepage "https://github.com/golang/tools/tree/master/gopls"
  url "https://github.com/golang/tools/archive/gopls/v0.8.4.tar.gz"
  sha256 "815060abeb22755352414ef62ffb265b2f0f9d38786c164595f85c9c25c8a7cb"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{(?:content|href)=.*?/tag/(?:gopls%2F)v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f0527083d31cbaf2a8e8c6efe85064f572595e074dc54d7f1421bd867336ed7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4c0ce67b991ebc991758a2d688f428f3824fb89423d73b8c4d0b125ecf497ac4"
    sha256 cellar: :any_skip_relocation, monterey:       "1cb4dfb00f2ea950068d9a433b3ebe5e5c5bb8ecc7209d9c293f2ec3d82f5896"
    sha256 cellar: :any_skip_relocation, big_sur:        "24bd7bb3984e3f752c85fd860cbcea64d9caa5eb7c2b4ff3c9d00e05768d3165"
    sha256 cellar: :any_skip_relocation, catalina:       "54ce5315e6e7325e82f25b11737d7a5cadf4a3afe32b1a3c5e45c182551c6fe3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15e897f3a75d55c2ae26a6abb34ecac448a72218e496d2dd6cad693b30b35213"
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

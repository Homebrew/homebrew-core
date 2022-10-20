class Gopls < Formula
  desc "Language server for the Go language"
  homepage "https://github.com/golang/tools/tree/master/gopls"
  url "https://github.com/golang/tools/archive/gopls/v0.9.5.tar.gz"
  sha256 "c7b3a09f3820a0b3183ab5a08845f8d328565076d2834bb3b049a12eff6191e5"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{(?:content|href)=.*?/tag/(?:gopls%2F)v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce87c819c820124beefa5bbbbebce0debc7a5e09f8aabbe3edd411b2ef692751"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "750e03de4f4e549a2d0839bc508d7a5952a601bfb93ff9fcfbffb2fa92545449"
    sha256 cellar: :any_skip_relocation, monterey:       "a25582739cb15e55d467371f212b2a1c9a5c55ece13bec02fb15926e76210f77"
    sha256 cellar: :any_skip_relocation, big_sur:        "870e5f82d58390fe6b4fec0e5b5aedde1fa8134ed314ec7bdaa73bd3f74d2c51"
    sha256 cellar: :any_skip_relocation, catalina:       "c2696acaaa0c1003e36f921440ebe28cecdc04a7c71a05005d0c6c483fbb2d27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c51c3ae4bc1c77bf788b3360ff4026bec42ae09f08a8efe7a311d5a0735314f7"
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

class Fx < Formula
  desc "Terminal JSON viewer"
  homepage "https://fx.wtf"
  url "https://github.com/antonmedv/fx/archive/refs/tags/24.0.0.tar.gz"
  sha256 "43682e6b189a84602930b9fb09a87af400359a9e97a4bb8e1119688c53fad9fd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f280c7957a0baea6ab964b3518aea0a58016002cc18b9a550d50d0773f190ba2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f280c7957a0baea6ab964b3518aea0a58016002cc18b9a550d50d0773f190ba2"
    sha256 cellar: :any_skip_relocation, monterey:       "0fcb17a478b4fe352e8842801d6b4f93ee019ebcdbedd7682ea2db06f947847c"
    sha256 cellar: :any_skip_relocation, big_sur:        "0fcb17a478b4fe352e8842801d6b4f93ee019ebcdbedd7682ea2db06f947847c"
    sha256 cellar: :any_skip_relocation, catalina:       "0fcb17a478b4fe352e8842801d6b4f93ee019ebcdbedd7682ea2db06f947847c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e88b4d24c1c7f497665c826115cfe5fd17642b9e66dca09c24062ef7d8b2f64a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_equal "42", pipe_output(bin/"fx", 42).strip
  end
end

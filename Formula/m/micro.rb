class Micro < Formula
  desc "Modern and intuitive terminal-based text editor"
  homepage "https://github.com/zyedidia/micro"
  url "https://github.com/zyedidia/micro.git",
      tag:      "v2.0.12",
      revision: "c2cebaa3d19fbdd924d411ee393c03e3e7804435"
  license "MIT"
  head "https://github.com/zyedidia/micro.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e862fde6a72c4ab3a00f2af45053d99f261e5f156ed0d93cf022f9baa287902b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8d1e433780ba9ffc846f7716a0a4c86ad8628121566c84f65b65c8016543ed59"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f9a34ed1e49c8b08eedc91efb2522884591c15f3205eac670a7c63337ec6c82"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4df3344c1a264887ef1c5bcbbe6096f85724848bd3d3185e6a7d4df5ae2f0856"
    sha256 cellar: :any_skip_relocation, sonoma:         "5b498cdf3fead470167cdf3cf1579d3edcae47d4afa2d9fad200e3386a2ddf50"
    sha256 cellar: :any_skip_relocation, ventura:        "4489c9ed74e1ce90b875f747c5439ccd1c1c7785592beaea366bb7744d8dd67d"
    sha256 cellar: :any_skip_relocation, monterey:       "4513082d0b19d003334b82e96811294a02ccd27c4d325566c381f5615dcb1bba"
    sha256 cellar: :any_skip_relocation, big_sur:        "1149fdfc8d1739156d293616f1cb7618862a335d4573dd6158c2840aaa7d1484"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6131012a517c1ae906ebb5a9011c90e6376626c3bea1b4d23d00c156d051e5bd"
  end

  depends_on "go" => :build

  def install
    system "make", "build-tags"
    bin.install "micro"
    man1.install "assets/packaging/micro.1"
    prefix.install_metafiles
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/micro -version")
  end
end

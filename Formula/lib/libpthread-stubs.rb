class LibpthreadStubs < Formula
  desc "X.Org: pthread-stubs.pc"
  homepage "https://www.x.org/"
  url "https://xcb.freedesktop.org/dist/libpthread-stubs-0.5.tar.xz"
  sha256 "59da566decceba7c2a7970a4a03b48d9905f1262ff94410a649224e33d2442bc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5a22f22ec7f8d78648e086389e2d7e314fd7007024d548292086c94654f5c702"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5a22f22ec7f8d78648e086389e2d7e314fd7007024d548292086c94654f5c702"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a22f22ec7f8d78648e086389e2d7e314fd7007024d548292086c94654f5c702"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5a22f22ec7f8d78648e086389e2d7e314fd7007024d548292086c94654f5c702"
    sha256 cellar: :any_skip_relocation, sonoma:         "5a22f22ec7f8d78648e086389e2d7e314fd7007024d548292086c94654f5c702"
    sha256 cellar: :any_skip_relocation, ventura:        "5a22f22ec7f8d78648e086389e2d7e314fd7007024d548292086c94654f5c702"
    sha256 cellar: :any_skip_relocation, monterey:       "5a22f22ec7f8d78648e086389e2d7e314fd7007024d548292086c94654f5c702"
    sha256 cellar: :any_skip_relocation, big_sur:        "5a22f22ec7f8d78648e086389e2d7e314fd7007024d548292086c94654f5c702"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e126aa201e8018f413bdf3e6a909eab1796c619237f7770bc1fd2ce31985a69"
  end

  depends_on "pkg-config"

  def install
    system "./configure", *std_configure_args.reject { |s| s["--disable-debug"] }
    system "make", "install"
  end

  test do
    system "pkg-config", "--exists", "pthread-stubs"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end

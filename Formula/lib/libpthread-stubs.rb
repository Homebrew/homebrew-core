class LibpthreadStubs < Formula
  desc "X.Org: pthread-stubs.pc"
  homepage "https://www.x.org/"
  url "https://xcb.freedesktop.org/dist/libpthread-stubs-0.5.tar.xz"
  sha256 "59da566decceba7c2a7970a4a03b48d9905f1262ff94410a649224e33d2442bc"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "303b8c21fc1b9322b6bd8f24e75a4e53a1c331d09b4f6271f75eba743d119819"
  end

  depends_on "pkgconf"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    assert_equal version.to_s, shell_output("pkgconf --modversion pthread-stubs").chomp
  end
end

class LibpthreadStubs < Formula
  desc "X.Org: pthread-stubs.pc"
  homepage "https://www.x.org/"
  url "https://xcb.freedesktop.org/dist/libpthread-stubs-0.5.tar.xz"
  sha256 "59da566decceba7c2a7970a4a03b48d9905f1262ff94410a649224e33d2442bc"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "1d085ebfa893354c02fb1a3c37dc6a5b16c8ecc8ba1fcfdf618be7068123c0ed"
  end

  depends_on "pkgconf" => :test

  deny_network_access!

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    assert_equal version.to_s, shell_output("pkgconf --modversion pthread-stubs").chomp
  end
end

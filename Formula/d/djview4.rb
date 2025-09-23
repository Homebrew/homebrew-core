class Djview4 < Formula
  desc "Viewer for the DjVu image format"
  homepage "https://djvu.sourceforge.net/djview4.html"
  url "https://downloads.sourceforge.net/project/djvu/DjView/4.12/djview-4.12.3.tar.gz"
  sha256 "17bfb9731ab8070e01235381f08e57b1231ffb5f49eb031873ebfa189cdaf47d"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/djview[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "b393017f8b974e7dc17a48f65941fc9ddde96ed8984d8512eee36c8696d92226"
    sha256 cellar: :any,                 arm64_ventura: "ad42188575bb0381ad12eacebd07697e2e9ff2d006ee8ce2f6f13ea4dedb3b20"
    sha256 cellar: :any,                 sonoma:        "7c6e8d7e367fb01bb6ab1ce25937baad8216b3eeba387c02b818f7181c5aded4"
    sha256 cellar: :any,                 ventura:       "feb0dbe394dd086949cb1c383b4d88999073173b84fbaadde047160c064c4bdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "782df64753001f0fcda840c52acda38ce36c0468d478eb05a669955e2c6f2b3c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "djvulibre"
  depends_on "libtiff"
  depends_on "qt"

  def install
    system "./autogen.sh", "--with-x=no",
                            "--disable-nsdejavu",
                            "--#{OS.mac? ? "disable" : "enable"}-desktopfiles",
                            "--#{OS.mac? ? "enable" : "disable"}-mac",
                            "--with-tiff=#{Formula["libtiff"].opt_prefix}",
                            *std_configure_args
    system "make", "CC=#{ENV.cc}", "CXX=#{ENV.cxx}"

    # From the djview4.8 README:
    # NOTE: Do not use command "make install".
    # Simply copy the application bundle where you want it.
    if OS.mac?
      # This script creates a more complete bundle, still relying on homebrew libs
      cd("mac") { system "sh", "./make_djview_bundle_small.sh" }
      prefix.install "mac/DjView.app"
      bin.write_exec_script prefix/"DjView.app/Contents/MacOS/djview"
    else
      # Should we use make install DESTDIR=<cellardir> instead?
      prefix.install "src/djview"
    end
  end

  test do
    name = if OS.mac?
      "DjView.app"
    else
      "djview"
    end
    assert_path_exists prefix/name
  end
end

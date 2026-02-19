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
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "97d3a20862eef89b5dff5f2792ee3f5b08adcbb5c4edfc50d350030a9c326c67"
    sha256 cellar: :any,                 arm64_sequoia: "b4e2f07c9690a2303f9b85c67ab95d6f5c2d6daa2da3bb8f64d69d36d3f003e8"
    sha256 cellar: :any,                 arm64_sonoma:  "c4a5109035da18e8d56d78b553bc9d5bccd348e588d5eb887e026db3860911d3"
    sha256 cellar: :any,                 sonoma:        "08d73ed6f8eab15a7ca0be2af8c9c5dd5464daef04ee28edea7167c9a84ba86a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "734c12e6abeba64b1a42dd2b7933be542c0b76c02cb9cdbb4dcbf7734f8a34af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aeb2ec0e8ceecffd35a1dde7d7b4a48a64dd762bab3225c711b8bc8cc3de3376"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "librsvg" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "qttools" => :build
  depends_on "djvulibre"
  depends_on "libtiff"
  depends_on "qt5compat"
  depends_on "qtbase"

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

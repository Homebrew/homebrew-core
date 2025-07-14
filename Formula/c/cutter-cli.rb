class CutterCli < Formula
  desc "Unit Testing Framework for C and C++"
  homepage "https://github.com/clear-code/cutter"
  url "https://osdn.mirror.constant.com/cutter/73761/cutter-1.2.8.tar.gz"
  sha256 "bd5fcd6486855e48d51f893a1526e3363f9b2a03bac9fc23c157001447bc2a23"
  license "LGPL-3.0-or-later"
  head "https://github.com/clear-code/cutter.git", branch: "master"

  livecheck do
    url "https://osdn.net/projects/cutter/releases/"
    regex(%r{value=["'][^"']*?/rel/cutter/v?(\d+(?:\.\d+)+)["']}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_sequoia: "97b85e3b955dc03407167d3278b8c2a1154847746b8be0966cd2651f32133db8"
    sha256 arm64_sonoma:  "6c6164fe937606eeeaafa7a2a8cd8315f6b529d28e1b3da1d2995d9a4e8b7ec6"
    sha256 arm64_ventura: "ee484be0a35af855d8f9b5c25e1b841ef8e1781f7d9d7bf8c248969ae0600ff1"
    sha256 sonoma:        "16040692fc81643261f574bdde9b9a8b3f6ac949b63c1cf710077be08f7827c9"
    sha256 ventura:       "0d964e970ffe413a8cb4b5a18b7c81f31a5bbaba243e7f9f8b39f7318445cc64"
    sha256 arm64_linux:   "220949ddfc4298e40a2f41ee5dea07b8c6c1253ffb092acd5e834e010bb79b48"
    sha256 x86_64_linux:  "7dabd19a5056216d962fb2164a401984cae70c0de41b5e1b859fa10785af4a2f"
  end

  depends_on "gettext" => :build
  depends_on "intltool" => :build
  depends_on "pkgconf" => :build
  depends_on "glib"

  uses_from_macos "perl" => :build

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "perl-xml-parser" => :build
  end

  def install
    ENV.prepend_path "PERL5LIB", Formula["perl-xml-parser"].libexec/"lib/perl5" unless OS.mac?

    system "./configure", "--prefix=#{prefix}",
                          "--disable-glibtest",
                          "--disable-goffice",
                          "--disable-gstreamer",
                          "--disable-libsoup"
    system "make"
    system "make", "install"
  end

  test do
    touch "1.txt"
    touch "2.txt"
    system bin/"cut-diff", "1.txt", "2.txt"
  end
end

class Biosig < Formula
  desc "Tools for biomedical signal processing and data conversion"
  homepage "https://biosig.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/biosig/BioSig%20for%20C_C%2B%2B/src/biosig-3.9.6.src.tar.xz"
  sha256 "916e1e7bfbb321ec11c6fb54d6d2582b35d07950a2c7ba15dad34ee722016e65"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/(?:biosig|biosig4c[^-]*?)[._-]v?(\d+(?:\.\d+)+)\.src\.t}i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "0da6ed7cf6c04b092ed8f42cf1aba88540e1c899cf7db55c9b8e427cb524cbd2"
    sha256 cellar: :any, arm64_sequoia: "25cc9192ac7232e38c7e13e57ea830046b01fe0918ef9d92be46e60e6981290d"
    sha256 cellar: :any, arm64_sonoma:  "ce77d060f51fa45eba51b66b6b153673635d6b276284e47a652392d83f68daae"
    sha256 cellar: :any, sonoma:        "8b054c1d7bf23da0407f035a200230c1c0ef656ec6da1117954e62dac5639955"
    sha256 cellar: :any, arm64_linux:   "16c9cd8857096437b99700fea4158bc0f4dfb940d063f70ef30e597a30e04c5a"
    sha256 cellar: :any, x86_64_linux:  "ce15382a752adc45965c78d8de99bdfd0796eb1232a60a289aa27af00110da03"
  end

  depends_on "gawk" => :build
  depends_on "libb64" => :build
  depends_on "dcmtk"
  depends_on "suite-sparse"

  def install
    ENV.append "CXX", "-std=gnu++17"

    # Work around header include order causing issues with `#ifndef isfinite`
    ENV.append "CXXFLAGS", "-include cmath" if DevelopmentTools.clang_build_version >= 1700

    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    # `string_isutf8.o` is missing from the libgdf link target
    inreplace "biosig4c++/Makefile.in",
              "gdf.o gdftime.o physicalunits.o getlogin.o",
              "gdf.o gdftime.o physicalunits.o getlogin.o string_isutf8.o"

    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    ENV.deparallelize if OS.mac? && MacOS.version >= :sonoma
    system "make", "install"
  end

  test do
    assert_match "usage: save2gdf [OPTIONS] SOURCE DEST", shell_output("#{bin}/save2gdf -h").strip
    assert_match "mV\t4274\t0x10b2\t0.001\tV", shell_output("#{bin}/physicalunits mV").strip
    assert_match "biosig_fhir provides fhir binary template for biosignal data",
                 shell_output("#{bin}/biosig_fhir 2>&1").strip
  end
end

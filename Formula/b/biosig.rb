class Biosig < Formula
  desc "Tools for biomedical signal processing and data conversion"
  homepage "https://biosig.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/biosig/BioSig%20for%20C_C%2B%2B/src/biosig-3.9.7.src.tar.xz"
  sha256 "b71fa7b8a7cc4c7d2a0ea16d47042a4a66ba43698c744a3b71a69d6fcf1ccfa4"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/(?:biosig|biosig4c[^-]*?)[._-]v?(\d+(?:\.\d+)+)\.src\.t}i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "37f39bfd605f6da1d37563029c74f9d419b36d9586900b2f733e2f3da2576cfa"
    sha256 cellar: :any, arm64_sequoia: "b0d9e8919b719485f19232cce52b76a7ba6b4759675729189d96eea8274a6e83"
    sha256 cellar: :any, arm64_sonoma:  "c3aaef34ae805829beab07c1949a6fb6afb689e2238a1446fbf9feaf4896374f"
    sha256 cellar: :any, sonoma:        "cdd3cddf257dd3bed2d121b0e34126b4f07a1d85cf812408b8a3d729cb6a7236"
    sha256 cellar: :any, arm64_linux:   "da8a370d8051c53976ec55c998ae3ab439bd6410e020781b2cd65f2b82149850"
    sha256 cellar: :any, x86_64_linux:  "5ae799c8168878bcacc3f5d541712382fa2d68645ef66618562c747e07becddb"
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

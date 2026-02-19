class Biosig < Formula
  desc "Tools for biomedical signal processing and data conversion"
  homepage "https://biosig.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/biosig/BioSig%20for%20C_C%2B%2B/src/biosig-3.9.3.src.tar.xz"
  sha256 "5173aa4c8c513ee1bd0ab1ab3f39bc4979f6d78d57c2abfffb507d1124f348e0"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/(?:biosig|biosig4c[^-]*?)[._-]v?(\d+(?:\.\d+)+)\.src\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5405b5e4b13988142d6db7c9144f71529d26555a4050ab6e9e5ccb2f1710b93c"
    sha256 cellar: :any,                 arm64_sequoia: "e33a85c2c2c77e28c41039d419bf587d512a545defab44e8caa2d3a66993b264"
    sha256 cellar: :any,                 arm64_sonoma:  "19d4654b105a9532d3021180b78486ee64c33176de76c04dde85f619d100e678"
    sha256 cellar: :any,                 sonoma:        "c391b7b35fa1ddc42df3e735832b637285371235e04060ff7c7917c797fb82f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4fc868c8a0302f4c1c6bed87614317ed8c186dd11a4bac6d012bf50a2766910d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5cba858086af774cc69cb73ade9e1584cf78a8e5195ccef9a16bb3836054d6d8"
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

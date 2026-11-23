class Biosig < Formula
  desc "Tools for biomedical signal processing and data conversion"
  homepage "https://biosig.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/biosig/BioSig%20for%20C_C%2B%2B/src/biosig-4.0.2.src.tar.xz"
  sha256 "85fce7d2f6985a99967a3f3e89c62080269c893e11d56b75393a499e46dd92ca"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/(?:biosig|biosig4c[^-]*?)[._-]v?(\d+(?:\.\d+)+)\.src\.t}i)
  end

  bottle do
    manifest_sha256 "80dc825e0d988c6a6a6219c8b63e62ad2a549d8acc7c7286b512ace479633eff"
    sha256 cellar: :any, arm64_golden_gate: "a7d080eb8d9398b462919f5d31c720591af4dbf77dd790bdfe195358e7e4a643"
    sha256 cellar: :any, arm64_tahoe:       "934125beefe1841e4e86a2a9974f4117b45b8c60d171b5ed6a50cb201b0ab6ac"
    sha256 cellar: :any, arm64_sequoia:     "2dbebf8617c1cb608a9453f1229347c4bc841173ae52fe0de869d867036836ac"
    sha256 cellar: :any, arm64_linux:       "34faed95b1d799ede08a887ef2ca1796bac9b137cd6185597237d0f3a59ac03c"
    sha256 cellar: :any, x86_64_linux:      "5744d5d9b4d3918bdf8d988bb7c2191a120beb80c9704417c38ad7406adfea61"
  end

  depends_on "gawk" => :build
  depends_on "libb64" => :build
  depends_on "dcmtk"
  depends_on "suite-sparse"

  deny_network_access!

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

    # Tools are linked with `$(LD)`, which is `$(CXX) -shared` on macOS, so they become dylibs
    args = OS.mac? ? ["LD=$(CXX)", "SHAREDLIB=-shared"] : []

    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", *args
    ENV.deparallelize if OS.mac? && MacOS.version >= :sonoma
    system "make", "install", *args
  end

  test do
    assert_match "usage: save2gdf [OPTIONS] SOURCE DEST", shell_output("#{bin}/save2gdf -h").strip
    assert_match "mV\t4274\t0x10b2\t0.001\tV", shell_output("#{bin}/physicalunits mV").strip
    assert_match "biosig_fhir provides fhir binary template for biosignal data",
                 shell_output("#{bin}/biosig_fhir 2>&1").strip
  end
end

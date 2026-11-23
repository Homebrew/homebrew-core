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
    manifest_sha256 "3f3a7adb7d06ac21fc8e4f6e3b40b6b898f36013818febcfd36d2f351abf3732"
    sha256 cellar: :any, arm64_golden_gate: "c62cd763e32b300d99704522fed6357a1a8960587ee8983d15bdb7345390571a"
    sha256 cellar: :any, arm64_tahoe:       "5999bd9b31871576844a06ad6081d7d116f225e4e3cde4e85d9d69e4b2498979"
    sha256 cellar: :any, arm64_sequoia:     "889946b19b99aa01250520c8988914fcea18f1e0ef786c067aa57b5f5338b9af"
    sha256 cellar: :any, arm64_linux:       "36f1fe7d5cecc2755f563d51579e5b2c41fa7e70d26f906a681bf35d789bc8c4"
    sha256 cellar: :any, x86_64_linux:      "1985dcf51521dd8dd9d9da0cc0e249ccc979cae3b0315e4a83762fe319a69caa"
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

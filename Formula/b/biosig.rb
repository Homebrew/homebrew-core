class Biosig < Formula
  desc "Tools for biomedical signal processing and data conversion"
  homepage "https://biosig.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/biosig/BioSig%20for%20C_C%2B%2B/src/biosig-4.0.0.src.tar.xz"
  sha256 "182a6dfe276f0217abd9cae81e1b515d590ddb9b44a98174ebbd4efe05927bac"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/(?:biosig|biosig4c[^-]*?)[._-]v?(\d+(?:\.\d+)+)\.src\.t}i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "fbcebb16f18801a62104f57ac6aa7c897478520eec032e230f0957cfd228fe62"
    sha256 cellar: :any, arm64_tahoe:       "b4427b3468999ddf9195a7e1dd6b6c973f457540b309ba8e3800d79540793503"
    sha256 cellar: :any, arm64_sequoia:     "93f3265be17eb1a8a916036c99b15234320893f89985bbf092a7b4a575304e86"
    sha256 cellar: :any, arm64_linux:       "d2d70ea3d7fa3511e95883f08f6a62dc2b6f81f211bbf3e72d1f88699902d64b"
    sha256 cellar: :any, x86_64_linux:      "352815c9b25abac34d6f022e44735725cada7b8378b33f538a73cddc1ebb9593"
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

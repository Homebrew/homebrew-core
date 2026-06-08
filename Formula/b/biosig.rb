class Biosig < Formula
  desc "Tools for biomedical signal processing and data conversion"
  homepage "https://biosig.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/biosig/BioSig%20for%20C_C%2B%2B/src/biosig-3.9.5.src.tar.xz"
  sha256 "dfdb7aec5ac9681f25e3c186a5b356d5ec86cda87cdcb034d38e838f875cc3f1"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/(?:biosig|biosig4c[^-]*?)[._-]v?(\d+(?:\.\d+)+)\.src\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8b266ef8a06ab3ad16f5bc5901a3150690e6f697c55e7d9e35d0d48624831210"
    sha256 cellar: :any,                 arm64_sequoia: "1298247915c0d2ab387988cc0ce677e7ee53a041006791bbb45a15ec81325d22"
    sha256 cellar: :any,                 arm64_sonoma:  "b9aecc456b99d4def2b35cf585dc5c80a8353c2d832bacf57a447ac98316ef8e"
    sha256 cellar: :any,                 sonoma:        "d3daa115222ba7b52440d46c4f93aecdb0b2054b43fb1642863c758704533ec0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6c91f66bc6ef8a0b955fd0d162d73df2a26fb65761970389aefb5a85900cd8e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df63c310a3deab0d6ba5f2027aab12fbd3370a001476c8980a0f8cbd46cce2b9"
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

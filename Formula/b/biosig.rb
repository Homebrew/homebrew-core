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
    sha256 cellar: :any, arm64_golden_gate: "185a7085e73fbe08153a7733bf4f7e5d71bb9bfec565b45ef7dbbc41f700b50e"
    sha256 cellar: :any, arm64_tahoe:       "ba1f148dd8fe9dcc8603bb5ad1d7e3a2ef104d8e50bf8e2b518009d8e587d3ec"
    sha256 cellar: :any, arm64_sequoia:     "0f53af3ae1d5f588dc59394d79bf569f7234ceee8f8abeece5216572a0e21a42"
    sha256 cellar: :any, arm64_linux:       "cc40ed7704bf3f129d0f0dfd4adb26bc8ec9db092b09ca956b84ec27f6c9e868"
    sha256 cellar: :any, x86_64_linux:      "4985747d1468da710df1d6af52be18292b2902a25fcea6413e7832bca1c6464c"
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

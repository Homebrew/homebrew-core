class Biosig < Formula
  desc "Tools for biomedical signal processing and data conversion"
  homepage "https://biosig.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/biosig/BioSig%20for%20C_C%2B%2B/src/biosig-2.6.1.src.tar.xz"
  sha256 "558ee17cd7b4aa1547e98e52bb85cccccb7f7a81600f9bef3a50cd5b34d0729e"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/(?:biosig|biosig4c[^-]*?)[._-]v?(\d+(?:\.\d+)+)\.src\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a88421331309918094ee177f00e8b6537ba8d6125a5507d73183275d770e372d"
    sha256 cellar: :any,                 arm64_monterey: "a94537bf985066694053ddcfe3a8254457ea0a9ed6acc4180da825dddb5a6537"
    sha256 cellar: :any,                 ventura:        "6a3926692abe3a19947778b679542669ea010075620ddbcb62240ff411e35026"
    sha256 cellar: :any,                 monterey:       "5136c7261264acb7dd2631527165f52074587979d988f09c9d551b94cdc48586"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "971e1c4a42c02b0d7bdcceea087f94f3d66314718f319108dcc019717beb0f78"
  end

  depends_on "gawk" => :build
  depends_on "libarchive" => :build
  depends_on "dcmtk"
  depends_on "libb64"
  depends_on "numpy"
  depends_on "suite-sparse"
  depends_on "tinyxml2"

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "usage: save2gdf [OPTIONS] SOURCE DEST", shell_output("#{bin}/save2gdf -h").strip
    assert_match "mV\t4274\t0x10b2\t0.001\tV", shell_output("#{bin}/physicalunits mV").strip
    assert_match "biosig_fhir provides fhir binary template for biosignal data",
                 shell_output("#{bin}/biosig_fhir 2>&1").strip
  end
end

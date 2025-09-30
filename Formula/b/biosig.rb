class Biosig < Formula
  desc "Tools for biomedical signal processing and data conversion"
  homepage "https://biosig.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/biosig/BioSig%20for%20C_C%2B%2B/src/biosig-3.9.0.src.tar.xz"
  sha256 "e5b353a1500e6f80150e1236919aef9679410a2337ee81ed056b3f306b25611e"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/(?:biosig|biosig4c[^-]*?)[._-]v?(\d+(?:\.\d+)+)\.src\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "70d70680271747ac17d076fc94b26449cca89b8c5f3c361488857a9e56dac07a"
    sha256 cellar: :any,                 arm64_sequoia: "152be2d169a73dbd8afcbb4e5060d547f7a0d439ed64626c6ccc969974d94e18"
    sha256 cellar: :any,                 arm64_sonoma:  "4d28f7a3f4ce3494c4557958c730b07bd08b19b8dbb056f7282f8e5fc396d918"
    sha256 cellar: :any,                 arm64_ventura: "738017ce88f7c9d43596aeeddc99ce04c6a6896ab02922da8c056ea24f3d0e6b"
    sha256 cellar: :any,                 sonoma:        "b410b16cdff030dfe233751c39c6523d5a841bd35bdd2e9cd153582b881d3f96"
    sha256 cellar: :any,                 ventura:       "0f235a6d5036c54a44fe76c5dd3b3cb321805ea72663b3abd1565674a3bd5856"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8bfe8bd446b18c50e95f60a1685c4ff47f1c7b3c0686799be786e2fd4b9ebb3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85ab1e23f4ec3552398ee860ee360c73eea317bc9e8881b90e1f9cc9d9069f02"
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

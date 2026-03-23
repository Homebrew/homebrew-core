class Biosig < Formula
  desc "Tools for biomedical signal processing and data conversion"
  homepage "https://biosig.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/biosig/BioSig%20for%20C_C%2B%2B/src/biosig-3.9.4.src.tar.xz"
  sha256 "4895c6f39fad85693e4aae36352a4b34f5a16e64c1feeade08c80bf1b3bb1a42"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/(?:biosig|biosig4c[^-]*?)[._-]v?(\d+(?:\.\d+)+)\.src\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f7be3b912dd5e0e7b69f1e5efd69a6aaf4f620741e102ff2acf3a3d827885634"
    sha256 cellar: :any,                 arm64_sequoia: "679db8676974d3a15f13984045c14090e256a2ff07443aa5684480902f8e89a2"
    sha256 cellar: :any,                 arm64_sonoma:  "3041c1746953c98c82c1180e9129bb012413815b4dfbd083e9428391058ccc31"
    sha256 cellar: :any,                 sonoma:        "77439da5eeafa68458b1a8b2ba661857f582e73ba826e17ff0a09089c090c570"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "49adde08cd6082bc6cafd69db23947e1a9684ad0d9a080360f5243667da73391"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7e362367ead115c1d7beb79d9fa2125abffdadf5b96a6faf2a8052564c6d062"
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

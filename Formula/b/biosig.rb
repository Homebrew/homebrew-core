class Biosig < Formula
  desc "Tools for biomedical signal processing and data conversion"
  homepage "https://biosig.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/biosig/BioSig%20for%20C_C%2B%2B/src/biosig-2.5.2.src.tar.xz"
  sha256 "3c87fa4ae6d69e1a75477f85451b6f16480418a0018d59e1586a2e3e8954ec47"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/(?:biosig|biosig4c[^-]*?)[._-]v?(\d+(?:\.\d+)+)\.src\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "83d191f0a0ac811bcf64c0c5112eed21d6a259f05d0b34be1e796e76a758d7f4"
    sha256 cellar: :any,                 arm64_monterey: "a4f03b4dd7ed99343a9c38635a032b18062d7987994a0771f366b365a3198665"
    sha256 cellar: :any,                 arm64_big_sur:  "08a1fd1b2ed45e852c449dec1fa31acfba84647102b686aa7dd80b2fc011dfd3"
    sha256 cellar: :any,                 ventura:        "2f62a6de7d6d95332d5786db95bd128a4f1e622588eb2484059ec11016cae52d"
    sha256 cellar: :any,                 monterey:       "16b28c2c2d7a6c51a5d36f2213cfb64fcbbfe0255aedfa98ff77c260dad8e107"
    sha256 cellar: :any,                 big_sur:        "ad212b7f5f76da51d0ef8b33c8b9d8a2e47e015f0cc218056d753e023fe0d267"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a39f2773b2ddf64ffa46b897c77cb09e2ba38ba93b274c2b4e49ba9d5ed4c20"
  end

  depends_on "gawk" => :build
  depends_on "libarchive" => :build
  depends_on "dcmtk"
  depends_on "libb64"
  depends_on "numpy"
  depends_on "suite-sparse"
  depends_on "tinyxml"

  def install
    # Workaround for Xcode 14.3
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

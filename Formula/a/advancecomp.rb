class Advancecomp < Formula
  desc "Recompression utilities for .PNG, .MNG, .ZIP, and .GZ files"
  homepage "https://www.advancemame.it/comp-readme.html"
  url "https://github.com/amadvance/advancecomp/releases/download/v2.6/advancecomp-2.6.tar.gz"
  sha256 "b07d77735540409771cbe1b6df165b5151c11bb9c3d8f01290be0ec88ec3498f"
  license "GPL-3.0-only"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "645f12c923d703bc3ebe073a81ae42f37f057a80f5be2e47def6e0c42455617e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3df6813916f0d8c24a7a17b68fc3cf37eaca1d9cd239dd9614541205a1ad5fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b1016a9d95dd57c4ea8521b53050211875d11c5b3528bde755c532c22c210d76"
    sha256 cellar: :any_skip_relocation, sonoma:        "e39bf043068c5ffb9dd0452ea3d6293f9bacd291c4364c05115f8539e2703b74"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0fe07baf766ba36840dbde997efba699f819afca12354bc8ec2f5ccd2c163c1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1795b527eb952aaa3e1300a6e76c0af53a612421f05245f207ee8b7bedb5a7f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--enable-bzip2", "--mandir=#{man}", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"advdef", "--version"

    cp test_fixtures("test.png"), "test.png"
    system bin/"advpng", "--recompress", "--shrink-fast", "test.png"

    version_string = shell_output("#{bin}/advpng --version")
    assert_includes version_string, "advancecomp v#{version}"
  end
end

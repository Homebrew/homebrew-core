class Byacc < Formula
  desc "(Arguably) the best yacc variant"
  homepage "https://invisible-island.net/byacc/"
  url "https://invisible-mirror.net/archives/byacc/byacc-20241231.tgz"
  sha256 "192c2fae048d4e7f514ba451627f9c4e612765099f819c19191f9fde3e609673"
  license :public_domain

  livecheck do
    url "https://invisible-mirror.net/archives/byacc/"
    regex(/href=.*?byacc[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b612e162124adb2c0a376645ec5a6fd73a32a048f93ff3f0a9cf822755ec9c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0efb664c82544393a02605e60e18599b8aeffcdf2cfae244a7f7336de1164e9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8ea708b5af936039ee437745f89d0db999464ab1dd68d7369e114b09315724c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "652bcab4132cf85526b03cdbfa52294d455500e566febe2891e118ca43351146"
    sha256 cellar: :any_skip_relocation, ventura:       "50253d20fdb4a50ffd1066fa33baddcbd912128cfc7474622bfea06114c1a5d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6bb26e744e5e9602d7c1ff3766f2578fb34c1a8a497d3cd02932650d2b6c2023"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--program-prefix=b", "--prefix=#{prefix}", "--man=#{man}"
    system "make", "install"
  end

  test do
    system bin/"byacc", "-V"
  end
end

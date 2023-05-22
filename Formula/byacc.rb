class Byacc < Formula
  desc "(Arguably) the best yacc variant"
  homepage "https://invisible-island.net/byacc/"
  url "https://invisible-mirror.net/archives/byacc/byacc-20230521.tgz"
  sha256 "5ad915a7d5833aa38a5e31bd077505666029c35e365dff8569fe4598eaa9fef2"
  license :public_domain

  livecheck do
    url "https://invisible-mirror.net/archives/byacc/"
    regex(/href=.*?byacc[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "38ce343287827cb635395e53d6335d31022e05e07cded481ace466889c003615"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c0cda08a52207ffec61486dd83aab12002b67f0e650cd7eb9170dc3596016fa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f2498ba1b3d8beb6c7c29f11763f1971707f708bd56c0dcdb2fe058f66cce3cc"
    sha256 cellar: :any_skip_relocation, ventura:        "559fd17c57ee319a5f0ffa0b04b2f42ffc3a0a6dbf0e85e3a42dc9cda059218f"
    sha256 cellar: :any_skip_relocation, monterey:       "309accb76b2f5daa03813ccf640da8396bec1d0540f83a13e85ed41d6b64b4ea"
    sha256 cellar: :any_skip_relocation, big_sur:        "420f2b6d7799a77f32c8ad2cd86b5a00218ad2019e2daa07f2d8f87559d3c242"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55dff71ab67cd1fc94db04da4501a5fe110d27bc18ce6918fa014c3ee1e423e3"
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

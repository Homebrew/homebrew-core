class Gpp < Formula
  desc "General-purpose preprocessor with customizable syntax"
  homepage "https://logological.org/gpp"
  url "https://files.nothingisreal.com/software/gpp/gpp-2.27.tar.bz2"
  sha256 "49eb99d22af991e7f4efe2b21baa1196e9ab98c05b4b7ed56524a612c47b8fd3"
  license "GPL-3.0"

  livecheck do
    url "https://github.com/logological/gpp.git"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f95e24da21e5bebe2701cdbc11e1d4e59fa1a0fd329ac31c04cbf9284e08388f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ccc07b5dd7a91cb1c0272648203721da1217ff473d1ced08670e1fc1b0e4a5eb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "614ed514c4443f444c66ba9f7da0a17ec8f3e2abb2469898e2c148462755893f"
    sha256 cellar: :any_skip_relocation, ventura:        "fc6aed9a5ca2e64eaadd1805b2997e492e3abd25a334ba858dbad1d9021c42fe"
    sha256 cellar: :any_skip_relocation, monterey:       "4af1b38dba8ef539286e03110f6a93081e8b46392918a28f3fd2ddd98295811c"
    sha256 cellar: :any_skip_relocation, big_sur:        "78cea18184e8b89cdf57b98095da58be0aed6931d9015f346b59972416aab72b"
    sha256 cellar: :any_skip_relocation, catalina:       "f6dcf32a23b4dfab4c9fa231757f87a9eb8f4ea2fcd4e8146a02e8afe22b38cc"
    sha256 cellar: :any_skip_relocation, mojave:         "54f5f9b098335023273291b6ec95615148ab3fa02039a0d7c1645cd59d0eb134"
    sha256 cellar: :any_skip_relocation, high_sierra:    "d56879d518d9924d17327594b31501c8ea4eaa58295e12ae41fc74156cffc179"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dffd92b648848b4548e77a32592772355aaa3a12ad779f8ab422728966e2871a"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    system "#{bin}/gpp", "--version"
  end
end

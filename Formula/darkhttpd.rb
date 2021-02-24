class Darkhttpd < Formula
  desc "Small static webserver without CGI"
  homepage "https://unix4lyfe.org/darkhttpd/"
  url "https://unix4lyfe.org/darkhttpd/darkhttpd-1.12.tar.bz2"
  sha256 "a50417b622b32b5f421b3132cb94ebeff04f02c5fb87fba2e31147d23de50505"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7fc5138e8e4af4039f2321403960ede2d5feba70fe6445decb14a48163f393c6"
    sha256 cellar: :any_skip_relocation, big_sur:       "090491867be6297c68dc7f31f80f42c62aad0a7288148442d0e764424936b881"
    sha256 cellar: :any_skip_relocation, catalina:      "9fbb24a5ba183c6e582a0a4960c86503ed6dca8b1fd37080f44c8516d0ef5117"
    sha256 cellar: :any_skip_relocation, mojave:        "5af24e2fb0bd38aec2b8b3c0bcf685b54297bde3e1311f2d38d48f0bf10912ab"
    sha256 cellar: :any_skip_relocation, high_sierra:   "b0da49675fa62225da80fd711cc426d2b58116355ae8c89c80de080479b777a5"
    sha256 cellar: :any_skip_relocation, sierra:        "1271ecbcd73b02bc8977235ea0bfcfdceb1819cb476213e74bd7d352df8a464f"
    sha256 cellar: :any_skip_relocation, el_capitan:    "cf8e5885072baed885238dc1a6b23466f80d96a32eb48d5f61f3b9d519df88b5"
    sha256 cellar: :any_skip_relocation, yosemite:      "2fc16040a837b47ac947b8462f93530a387f9db0e0d6a594e4b7dba3437e6e11"
    sha256 cellar: :any_skip_relocation, mavericks:     "0ac0b5be3f8e944981806ed255740a6feaee64cd14d78d817e8c5a75391d9837"
  end

  def install
    system "make"
    bin.install "darkhttpd"
  end

  test do
    system "#{bin}/darkhttpd", "--help"
  end
end

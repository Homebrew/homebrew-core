class Darkhttpd < Formula
  desc "Small static webserver without CGI"
  homepage "https://unix4lyfe.org/darkhttpd/"
  url "https://unix4lyfe.org/darkhttpd/darkhttpd-1.12.tar.bz2"
  sha256 "a50417b622b32b5f421b3132cb94ebeff04f02c5fb87fba2e31147d23de50505"

  bottle do
    cellar :any_skip_relocation
    sha256 "5af24e2fb0bd38aec2b8b3c0bcf685b54297bde3e1311f2d38d48f0bf10912ab" => :mojave
    sha256 "b0da49675fa62225da80fd711cc426d2b58116355ae8c89c80de080479b777a5" => :high_sierra
    sha256 "1271ecbcd73b02bc8977235ea0bfcfdceb1819cb476213e74bd7d352df8a464f" => :sierra
    sha256 "cf8e5885072baed885238dc1a6b23466f80d96a32eb48d5f61f3b9d519df88b5" => :el_capitan
    sha256 "2fc16040a837b47ac947b8462f93530a387f9db0e0d6a594e4b7dba3437e6e11" => :yosemite
    sha256 "0ac0b5be3f8e944981806ed255740a6feaee64cd14d78d817e8c5a75391d9837" => :mavericks
  end

  def install
    system "make"
    bin.install "darkhttpd"
  end

  test do
    system "#{bin}/darkhttpd", "--help"
  end
end

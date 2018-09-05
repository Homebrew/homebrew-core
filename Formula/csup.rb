class Csup < Formula
  desc "Rewrite of CVSup in C"
  homepage "https://bitbucket.org/mux/csup"
  url "https://bitbucket.org/mux/csup/get/REL_20120305.tar.gz"
  sha256 "6b9a8fa2d2e70d89b2780cbc3f93375915571497f59c77230d4233a27eef77ef"
  revision 1
  head "https://bitbucket.org/mux/csup", :using => :hg

  bottle do
    rebuild 1
    sha256 "3aa3e72c6f104818b1d20d3da7a91082372f1a2291dd4df44a646091b7cdbb92" => :mojave
    sha256 "14207f528521fa0ebec31802647c97a7fc68705333b9b85e13b1ca49abc3ecfa" => :high_sierra
    sha256 "48e552e85834b44fbaf0c09fef9e0f6e4b8768684973dd8ad632e778d228aa75" => :sierra
    sha256 "e5fc8b0e31fa2f93dccde05ad0b431150c8fb925ee2ab357878f01f1ba5264c2" => :el_capitan
  end

  depends_on "openssl"

  def install
    system "make"
    bin.install "csup"
    man1.install "csup.1"
  end

  test do
    system "#{bin}/csup", "-v"
  end
end

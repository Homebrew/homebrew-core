class Mairix < Formula
  desc "Email index and search tool"
  homepage "http://www.rpcurnow.force9.co.uk/mairix/"
  url "https://downloads.sourceforge.net/project/mairix/mairix/0.23/mairix-0.23.tar.gz"
  sha256 "804e235b183c3350071a28cdda8eb465bcf447092a8206f40486191875bdf2fb"

  head "https://github.com/rc0/mairix.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0a7ee5ac029afa61f328a1c316e9dfc8be3d5f2ae66951599305b432e3b80bc8" => :sierra
    sha256 "453f15461f87619409983ab90620d5bb57d151a3f3485d08d3e5a9e26c59713d" => :el_capitan
    sha256 "f41193f4f7ca899f5ad2ecd8ef9e1fab3b6810f008b2ea8e55d310dba8c7a795" => :yosemite
    sha256 "4fadb513b3478d776d3a23e8352015b18f45a4347a50b2fed988f1729a7336e7" => :mavericks
  end

  def install
    ENV.j1
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make", "install"
  end
end

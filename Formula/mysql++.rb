class Mysqlxx < Formula
  desc "C++ wrapper for MySQL's C API"
  homepage "https://tangentsoft.net/mysql++/"
  url "https://tangentsoft.net/mysql++/releases/mysql++-3.2.1.tar.gz"
  sha256 "aee521873d4dbb816d15f22ee93b6aced789ce4e3ca59f7c114a79cb72f75d20"

  bottle do
    cellar :any
    sha256 "5b9157f16cfb22913df17332f1a465972aa3333968201a002a017b2a2744f2f7" => :sierra
    sha256 "5f2dbe4f6d66aefaa8be4cc3ae817c1f6b5230b3848dd5585c68a902ea354637" => :el_capitan
    sha256 "c08d5308c6b973026e75f2504755eeca5a348569860d215fc24e31f52e4510cd" => :yosemite
    sha256 "2b097aed1f7d0ba9bb22b521e011464daa30ce08714d5fca7445a437cda50f3a" => :mavericks
    sha256 "154e219e9cac151437d47b281ca35aa35eaf3d510b04f5e9886a0257a983a760" => :mountain_lion
  end

  depends_on "mysql-connector-c"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-field-limit=40",
                          "--with-mysql-lib=#{HOMEBREW_PREFIX}/lib",
                          "--with-mysql-include=#{HOMEBREW_PREFIX}/include"
    system "make", "install"
  end
end

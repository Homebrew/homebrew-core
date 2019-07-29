class Namazu < Formula
  desc "Full-text search engine"
  homepage "http://www.namazu.org/"
  url "http://www.namazu.org/stable/namazu-2.0.21.tar.gz"
  sha256 "5c18afb679db07084a05aca8dffcfb5329173d99db8d07ff6d90b57c333c71f7"

  bottle do
    rebuild 1
    sha256 "f6140424ff2a5a5bee20b4430036ce76bd66bf82705cd0a1fa52790caf617fea" => :mojave
    sha256 "15f536a0c9e3212af68689dc2202ae0d9a7634d161aa0ac3aa6d55977506f8da" => :high_sierra
    sha256 "2514d7e9209225e9f388feda1116c193ec98034952dd9c6b89bcaccafabedb1f" => :sierra
    sha256 "39cad2ecd3948e2afd69fc58b6390e1fd7fa7e82cee8176fec7f71880c6e52c2" => :el_capitan
    sha256 "01a0bf11f2ad2095306055016b430c19900ea6203af5fcf4bb5c92c085d44a67" => :yosemite
    sha256 "ca6e854a626eaafd4ac26661b9a3db86dc9bc140f4aa98effd5843882aba7ecb" => :mavericks
  end

  def install
    cd "File-MMagic" do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make", "install"
    end

    args = ["--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--mandir=#{man}",
            "--with-pmdir=#{libexec}/lib/perl5"]
    system "./configure", *args
    system "make", "install"
  end

  test do
    data_file = testpath/"data.txt"
    data_file.write "This is a Namazu test case for Homebrew."
    mkpath "idx"

    system bin/"mknmz", "-O", "idx", data_file
    search_result = shell_output("#{bin}/namazu -a Homebrew idx")
    assert_match /#{data_file}/, search_result
  end
end

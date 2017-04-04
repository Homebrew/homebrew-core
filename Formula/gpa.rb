class Gpa < Formula
  desc "Graphical user interface for the GnuPG"
  homepage "https://www.gnupg.org/related_software/gpa/"
  url "https://gnupg.org/ftp/gcrypt/gpa/gpa-0.9.10.tar.bz2"
  sha256 "c3b9cc36fd9916e83524930f99df13b1d5f601f4c0168cb9f5d81422e282b727"

  bottle do
    sha256 "d5baa06c7a51ff89253bebf327b775947eea55cb0f4e82d938c3287dcfc46be4" => :sierra
    sha256 "f1d250fe4cc77d8a5ee1fc43dcb77b96942793338b8cf0d568a164254756c0a5" => :el_capitan
    sha256 "9066c49c0cc60b66838064e47d85e64ab36d132b44ab5eeaaff1cc32edc53948" => :yosemite
    sha256 "1756a93cf8ab4265fb6ce71a86de51f184b863cf2772ddcf8aacf148187ee1ac" => :mavericks
  end

  depends_on "desktop-file-utils"
  depends_on "gpgme"
  depends_on "gtk+"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/gpa", "--version"
  end
end

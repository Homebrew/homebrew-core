class Nickle < Formula
  desc "Desk calculator language"
  homepage "https://www.nickle.org/"
  url "https://www.nickle.org/release/nickle-2.81.tar.gz"
  sha256 "99a9331489e290fb768bf8d88e8b03e76f25485d7636c30d9eee616ca9d358b5"

  bottle do
    sha256 "32d7348bd2d8201b3e72a875d2b8f9de280cdeb15b43d8c5cf635941f7807ee5" => :high_sierra
    sha256 "a4bf85c667af66a966bfba67f0bc3caea752ae13a808133c928509c80edca796" => :sierra
    sha256 "40df920677e85b1ded1911a88e70d46b35c1379fa06ef60e96bbff3b3990ae16" => :el_capitan
  end

  depends_on "readline"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "4", shell_output("#{bin}/nickle -e '2+2'").chomp
  end
end

class Nickle < Formula
  desc "Desk calculator language"
  homepage "http://www.nickle.org/"
  url "http://www.nickle.org/release/nickle-2.77.tar.gz"
  sha256 "a35e7ac9a3aa41625034db5c809effc208edd2af6a4adf3f4776fe60d9911166"
  revision 1

  bottle do
    sha256 "4da54c90a2fd5ae249b51822d78b98d48a87bea56f96e45b3de60d016ea74fc4" => :sierra
    sha256 "8800a7c9508372d13a9d72e75c0db9d5aade8b1cb919b369da65574831b7f086" => :el_capitan
    sha256 "bd50768f3a76f35e0343eb44ece0e7c756782dbecfc408a7519ee8202a396907" => :yosemite
    sha256 "d153d5db01c1b232a472958310d0529ad1e845b1bbfc785f025523e21a5bffa9" => :mavericks
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

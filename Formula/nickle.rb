class Nickle < Formula
  desc "Desk calculator language"
  homepage "https://www.nickle.org/"
  url "https://www.nickle.org/release/nickle-2.81.tar.gz"
  sha256 "99a9331489e290fb768bf8d88e8b03e76f25485d7636c30d9eee616ca9d358b5"

  bottle do
    sha256 "34c498d8b9924529193669f9cec5e1a7d648dfd48430496c0d01bf3b38da4ca2" => :high_sierra
    sha256 "54d986151e2e52e2212ce1e00b887ec1cfbebba67f621f62742a2890b16302c1" => :sierra
    sha256 "c1bfe5ca6ecb8327970fdc34a6e5caa85e521ceb317981913a72068049514674" => :el_capitan
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

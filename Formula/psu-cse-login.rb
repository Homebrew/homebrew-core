class PsuCseLogin < Formula
  desc "Login helper for PSU CSE students"
  homepage "https://github.com/Seancheey/psu-cse-login"
  url "https://github.com/Seancheey/psu-cse-login/archive/0.4.tar.gz"
  sha256 "1b2c50060140f3cdcece908363dc429c7a259ca954eb433640019ec88359c53e"
  head "https://github.com/Seancheey/psu-cse-login.git"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_predicate bin/"cse-login", :exist?
  end
end

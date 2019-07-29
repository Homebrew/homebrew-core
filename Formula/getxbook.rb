class Getxbook < Formula
  desc "Tools to download ebooks from various sources"
  homepage "https://njw.name/getxbook"
  url "https://njw.name/getxbook/getxbook-1.2.tar.xz"
  sha256 "7a4b1636ecb6dace814b818d9ff6a68167799b81ac6fc4dca1485efd48cf1c46"

  bottle do
    cellar :any
    rebuild 1
    sha256 "e41dd2cae656b3dc6d0fd3b40a4f5b1a4abf3201810a4b4ede48a4b5be1c57f6" => :mojave
    sha256 "22e0f30ddca62fe58ef3e8c85cbd9c2c0d56af80752650680fd80c6653de3cad" => :high_sierra
    sha256 "5a3715317211d006cf7be4f0f2b86955be586790461c9d0e27f0202fa8851f65" => :sierra
  end

  depends_on "openssl"

  def install
    system "make", "CC=#{ENV.cc}", "PREFIX=#{prefix}"
    bin.install "getgbook", "getabook", "getbnbook"
  end

  test do
    assert_match "getgbook #{version}", shell_output("#{bin}/getgbook", 1)
  end
end

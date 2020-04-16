class Apib < Formula
  desc "HTTP performance-testing tool"
  homepage "https://github.com/apigee/apib"
  url "https://github.com/apigee/apib/archive/APIB_1_2_1.tar.gz"
  sha256 "e47f639aa6ffc14a2e5b03bf95e8b0edc390fa0bb2594a521f779d6e17afc14c"
  head "https://github.com/apigee/apib.git"

  bottle do
    cellar :any
    sha256 "89a8653925243569be382dc7a7816a836e020973e627ba0a0b3926e3de0ba684" => :catalina
    sha256 "ca59f86634b3b9282496f95b432aa9e0c9924eb189c1ec2965d427edac8bab4e" => :mojave
    sha256 "f2adc68de1b28e305ad7530ec097425bcf75beb70d6dd820f025cabcbeb54585" => :high_sierra
    sha256 "bbe9bc25a8584f163347662675d78b69cdfaac495be5f2fa026dfca112f8d4a4" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "libev"
  depends_on "openssl@1.1"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "apib", "apibmon"

    bin.install "apib/apib", "apib/apibmon"
  end

  test do
    system "#{bin}/apib", "-c 1", "-d 1", "https://www.google.com"
  end
end

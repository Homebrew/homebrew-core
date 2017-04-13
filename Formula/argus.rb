class Argus < Formula
  desc "Audit Record Generation and Utilization System server"
  homepage "https://qosient.com/argus/"
  url "https://qosient.com/argus/src/argus-3.0.8.2.tar.gz"
  sha256 "ca4e3bd5b9d4a8ff7c01cc96d1bffd46dbd6321237ec94c52f8badd51032eeff"

  bottle do
    cellar :any_skip_relocation
    sha256 "ed5c7ac2bdbc0b8b8fd3f0dccc878b2618f91c736e9db428bc35c800f06a1519" => :sierra
    sha256 "422d8a3a75e0c6d4095200c38e33722721acd8826f2833e6fe2269a5dc307c92" => :el_capitan
    sha256 "7e369883e4ef8eda6efd19eb31ba83f619fc13b758e40ade9f199c696e9e37b5" => :yosemite
    sha256 "6f6b81839f5f6a23b3a0be14bea615dab821bbe8be7dbfae886871ad41590191" => :mavericks
    sha256 "10f68e1435d342133a0d0fbcfc878b9f01fd95fa2d83f0e3adff7fdfaa1f3185" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "Pages", shell_output("#{bin}/argus-vmstat")
  end
end

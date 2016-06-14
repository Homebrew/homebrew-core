class Ntl < Formula
  desc "C++ number theory library"
  homepage "http://www.shoup.net/ntl"
  url "http://www.shoup.net/ntl/ntl-9.9.1.tar.gz"
  sha256 "bc0b8ea7b671395b2346c93ac7ed7ed2ee216ec6ff9fd6ebfb8eb0ddc993c787"

  bottle do
    cellar :any_skip_relocation
    sha256 "b2e49f847d542cb590e61c9bc42f61e14a9734253376139ee921f721270a0359" => :el_capitan
    sha256 "e6e5d4d8a2ceebab398cf07046302deb58b51436cb1c58842a5aa3421229eca7" => :yosemite
    sha256 "08e30b7e8157984b72483ecc2141e892eb9ec2884ec4285138851b3e4373ccba" => :mavericks
  end

  depends_on "gmp"

  def install
    args = ["PREFIX=#{prefix}"]

    cd "src" do
      system "./configure", *args
      system "make"
      system "make", "check"
      system "make", "install"
    end
  end
end

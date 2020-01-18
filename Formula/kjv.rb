class Kjv < Formula
  desc "Read the Word of God from your terminal"
  homepage "https://github.com/ipstone/kjv"
  url "https://github.com/ipstone/kjv/releases/download/v1.0.0/kjv.tar.gz"
  sha256 "d7320a9522ca518074f36d40b4807f8b995d951be0190715a49b79c33ff083e9"

  depends_on "make" => :build
  depends_on "awk"

  def install
    system "make"
    bin.install "kjv"
  end

  test do
    # Test if kjv will output the help page
    system "kjv", "-h"
    return true
  end
end

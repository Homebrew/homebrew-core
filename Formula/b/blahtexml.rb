class Blahtexml < Formula
  desc "Converts equations into Math ML"
  homepage "https://github.com/gvanas/blahtexml"
  url "https://github.com/gvanas/blahtexml/archive/refs/tags/v1.0.tar.gz"
  sha256 "ef746642b1371f591b222ce3461c08656734c32ad3637fd0574d91e83995849e"
  license "BSD-3-Clause"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ff3728fa3b6cd2729e13bf73a0f4bf9bd7be61b9296f3ec524a9898a4722a256"
    sha256 cellar: :any,                 arm64_sequoia: "60f47cf24ae5bd4f52cf4aa2030b663593416a2af1a4cb8777eb62c9c372b6f6"
    sha256 cellar: :any,                 arm64_sonoma:  "e82e2cc31b503539d5db79bd19954cbfe6f7fbcfaea9ba16a28a57b83289f68a"
    sha256 cellar: :any,                 arm64_ventura: "3a9444e47913a2712d6ebb56557368a847a25f597c6814ff8665ff6acdb3157b"
    sha256 cellar: :any,                 sonoma:        "98a072e29a975511bf7ccd60a9f701b15c6fe1d14a9756dfd36db003fc79d3b6"
    sha256 cellar: :any,                 ventura:       "33b2552f46a52197ba7964e9ad863ac7aa021843c3aa35af47e2d2dcdcfe9ed7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "647ed1ee2095b2c6c37fdbdcda7e448ed8df07f34779a03e79dd0763f5acca8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3931e63cdf1ec35393bc437441f1edc43413ba92760a1497de59a59fcc70e5bf"
  end

  depends_on "xerces-c"

  def install
    ENV.cxx11
    if OS.mac?
      system "make", "blahtex-mac"
      system "make", "blahtexml-mac"
    else
      system "make", "blahtex-linux"
      system "make", "blahtexml-linux"
    end
    bin.install "blahtex"
    bin.install "blahtexml"
  end

  test do
    input = '\sqrt{x^2+\alpha}'
    output = pipe_output("#{bin}/blahtex --mathml", input, 0)
    assert_match "<msqrt><msup><mi>x</mi><mn>2</mn></msup><mo ", output
  end
end

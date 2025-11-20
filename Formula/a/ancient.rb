class Ancient < Formula
  desc "Decompression routines for ancient formats"
  homepage "https://github.com/temisu/ancient"
  url "https://github.com/temisu/ancient/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "5d1d71f0fb8c69955bb4ec01ed9ffd2b5bf546b10463030dda85d949ea422bc9"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6817d9ce2e9d71f8e176280373905983d18dc6984a8cb9fd8587a77189ed77a3"
    sha256 cellar: :any,                 arm64_sequoia: "08b6b80e0b301194514d37f7bcbfbb9f3f6741a5f76d26d11238591d4095481a"
    sha256 cellar: :any,                 arm64_sonoma:  "bff6bffe97748fcafa7153b84ab9f4e777140bcd61b283368e1700d059b7a248"
    sha256 cellar: :any,                 sonoma:        "e7d17674bacf02c4c01a07812e801e662b76fd68de9ad82287bf1fd65c4e2e18"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3c75d64ba336cfa2c79cff5db5f0f918f95448565e93685df2679d25b429aac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc2e89a54843d08f940bf5a541e85ad5ae0ece2fa2f5b146a2e22a792ced7a2e"
  end

  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <ancient/ancient.hpp>

      int main(int argc, char **argv)
      {
        std::optional<ancient::Decompressor> decompressor;
        return 0;
      }
    CPP

    system ENV.cxx, "-std=c++17", "test.cpp", "-I#{include}", "-L#{lib}", "-lancient", "-o", "test"
    system "./test"
  end
end

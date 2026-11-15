class Openh264 < Formula
  desc "H.264 codec from Cisco"
  homepage "https://www.openh264.org/"
  url "https://github.com/cisco/openh264/archive/refs/tags/v2.7.0.tar.gz"
  sha256 "5178775c8b440073e70920e97d195efff721c0e56d0a78cc82c919e95d54924d"
  license "BSD-2-Clause"
  head "https://github.com/cisco/openh264.git", branch: "master"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "95c21ec2da9a56cbfaef773dcc57d3a3a7bd352398797b0614f7d2f539913f6e"
    sha256 cellar: :any, arm64_tahoe:       "beb1f422f033063113f72bd58ce3a02d5bb18d9a771b817c22cd571f48ead5e2"
    sha256 cellar: :any, arm64_sequoia:     "0b632e539507e013588158f6166725a7ca3e513d4d53014df812108095c4d49a"
    sha256 cellar: :any, arm64_linux:       "7aed38887c4237fb733c06fa1629d0376e834ff50cfff7a257fc8726e06585b5"
    sha256 cellar: :any, x86_64_linux:      "1a4d77ef4bd7268821be569d2d8c8317931e557c5dfae262e6a3223af723b47c"
  end

  on_intel do
    depends_on "nasm" => :build
  end

  def install
    system "make", "install-shared", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <wels/codec_api.h>
      int main() {
        ISVCDecoder *dec;
        WelsCreateDecoder (&dec);
        WelsDestroyDecoder (dec);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lopenh264", "-o", "test"
    system "./test"
  end
end

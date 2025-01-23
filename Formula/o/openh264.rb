class Openh264 < Formula
  desc "H.264 codec from Cisco"
  homepage "https://www.openh264.org/"
  url "https://github.com/cisco/openh264/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "94c8ca364db990047ec4ec3481b04ce0d791e62561ef5601443011bdc00825e3"
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
    sha256 cellar: :any,                 arm64_sequoia: "93f1b2f1c050d2e5bf0479c09a09fbdbea71285ade4a7e185055dd0c087018a6"
    sha256 cellar: :any,                 arm64_sonoma:  "8c5eaf8bcb2c973e8b3a78f2d08d502662c212f26b5d5f23a85a3804eff652f7"
    sha256 cellar: :any,                 arm64_ventura: "562c9fba739b35c698d911ad76c8cd6459c4809f1ec9d7f12a0d202efb9bca2a"
    sha256 cellar: :any,                 sonoma:        "1457d067340742d322d16e82a446e4c390f8c227565b8d2e5f755653e9ca014c"
    sha256 cellar: :any,                 ventura:       "9191b1ee21792f3292064b6e359c48f541aa3e113d26658fc2caa97edd534369"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0fbebf84790e261e5928cdd7032d1d33d11c9d3bf493a65aa78da1d402f7723"
  end

  depends_on "nasm" => :build

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

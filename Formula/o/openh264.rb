class Openh264 < Formula
  desc "H.264 codec from Cisco"
  homepage "https://www.openh264.org/"
  url "https://github.com/cisco/openh264/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "558544ad358283a7ab2930d69a9ceddf913f4a51ee9bf1bfb9e377322af81a69"
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
    sha256 cellar: :any,                 arm64_tahoe:   "66b45539594a83afa29294059d4b82cbfeb149549cf90f6034c4c786db39486f"
    sha256 cellar: :any,                 arm64_sequoia: "a515a7ef81ee79369a4e607c78d14e1c6d778b799d75bd53a45f78bfcd512f0a"
    sha256 cellar: :any,                 arm64_sonoma:  "ee76a655687d6e7ce9bc7f9734212e609be33f96c7cce20b9706ba206a5cac19"
    sha256 cellar: :any,                 arm64_ventura: "d5934c079e354517b1241ad91fcdfa8ffc2a3eeb023ab50288fd18141492d04f"
    sha256 cellar: :any,                 sonoma:        "8ccc47d06160704ddd908e021aa95d8f9e57c99b50d72eb4392bcc15bff2a1c5"
    sha256 cellar: :any,                 ventura:       "f15c605ca3e71e932c65c4fb1c9cfe5ff67343c0743bf15181f4172f05e567e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca36990de40af30ea3f0175926c87baaa780ad0e0abddc3328f69e22fc4ff908"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a5b7c2ddbf8e02c9590b66e49e25119cf06ca2ff1ca48bb85f89c498828304e"
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

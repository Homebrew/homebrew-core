class Bgrep < Formula
  desc "Like grep but for binary strings"
  homepage "https://github.com/tmbinc/bgrep"
  url "https://github.com/tmbinc/bgrep/archive/refs/tags/bgrep-0.3.tar.gz"
  sha256 "a54ad3101150d750c180718b487406bef630f062a5ef30fde59be10a7caaaf1e"
  license "BSD-2-Clause"
  head "https://github.com/tmbinc/bgrep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "65a1d9a13a91fbdb792336d6a550ae4e5c4b84975926082c64727d8a28533107"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c81e8fda28328340dc30f6e6f6ab96c389b5634b81a42b834e33a12203e91f65"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff8d404ad35900f55bfd9342ad8c11ae9884b4186b9d35c8cfffa823f190ce4c"
    sha256 cellar: :any_skip_relocation, sonoma:        "380bd3d07c2b2feb61142defae38c094602e9addb18a838aed6ec1d0af26d9dc"
    sha256 cellar: :any,                 arm64_linux:   "ac85e305579a4ae6e25580ce8d260908aef34ac33d683ff3476eaa743ab31220"
    sha256 cellar: :any,                 x86_64_linux:  "f6dfa7034085b0560b2a86a28db8b4de0c55a4efcc8c2112d9560e04dfe72130"
  end

  def install
    args = %w[bgrep.c -o bgrep]
    args << ENV.cflags if ENV.cflags.present?
    system ENV.cc, *args
    bin.install "bgrep"
  end

  test do
    path = testpath/"hi.prg"
    path.binwrite [0x00, 0xc0, 0xa9, 0x48, 0x20, 0xd2, 0xff,
                   0xa9, 0x49, 0x20, 0xd2, 0xff, 0x60].pack("C*")

    assert_equal "#{path}: 00000004\n#{path}: 00000009\n",
                 shell_output("#{bin}/bgrep 20d2ff #{path}")
  end
end

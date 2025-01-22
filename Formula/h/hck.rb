class Hck < Formula
  desc "Sharp cut(1) clone"
  homepage "https://github.com/sstadick/hck"
  url "https://github.com/sstadick/hck/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "7b3d2e61d1e0014184e111c86a0ef92437820f9a090effa43bce6af2c220b315"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/sstadick/hck.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a4f7c52884ffae92ceef635acdda542e37b4aff4c4b4d27a1146b62886949fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "daa063259c96328b3831aea3ab2e6d3bc6844d7b0dd4d120c5e203f0658eb610"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d99340dfa7b6251cf578f888599da7fff55f87bc12066e55f9ebe52d6eb82fe6"
    sha256 cellar: :any_skip_relocation, sonoma:        "87e61fc6932eb1fb9a4fee02c1dbcd81154813e0e7915240913b975484e88579"
    sha256 cellar: :any_skip_relocation, ventura:       "cb6d4a89264fb160c1c8250a20b130f940814e9e5df5fbbcceb81a4a676ae8a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f66f7609187b084c1cbb7b0336d333bfa87822760d211bfdef0edc81d63f0b3e"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = pipe_output("#{bin}/hck -d, -D: -f3 -F 'a'", "a,b,c,d,e\n1,2,3,4,5\n")
    expected = <<~EOS
      a:c
      1:3
    EOS
    assert_equal expected, output

    assert_match version.to_s, shell_output("#{bin}/hck --version")
  end
end

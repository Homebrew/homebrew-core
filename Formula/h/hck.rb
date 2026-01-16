class Hck < Formula
  desc "Sharp cut(1) clone"
  homepage "https://github.com/sstadick/hck"
  url "https://github.com/sstadick/hck/archive/refs/tags/v0.11.5.tar.gz"
  sha256 "5ce5fc816e9e009dafe8c42a0bd6b9e6c8b7ca5a839af6a797fba9accc569242"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/sstadick/hck.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2b701fbd9c9c3255cf08902aafec7534565d6b72be454aa8d65ca60b2a56fcd0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eebac3b042a4687b2299d79c7660c48cecfe8377da44250bf16887c7310d8079"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb5c2973e5cf849f5a67053cbf186cac6669dbb42399daebf932063a96118cac"
    sha256 cellar: :any_skip_relocation, sonoma:        "b3e7fb8cb36a5b462e1200194705dc74ea3a94b31521d0a1a56eac2d0729d1f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4eab96ce3ffb5740ea3c317e7b2b249b6d98c48bf784a9e3ab912cfefbbb36e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75760e081bfd9fac813e1288abae8a6671399ebee192bde6fc9d7e2e82fb63df"
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

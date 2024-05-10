class Hck < Formula
  desc "Sharp cut(1) clone"
  homepage "https://github.com/sstadick/hck"
  url "https://github.com/sstadick/hck/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "6a90bc7e7f93489149262f5551efb611cd874e938ba7d459a2c4254031301317"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/sstadick/hck.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "452712cfa3b9840c9339c95c2725be781f536d25ebf011f318430d085d9a6b57"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7d56075d9f3619752ffc0080800c22dac950e853e0335da3c2a5ae0004afdc0c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "591293e5d346ccb262a7bf4e90234047750d6f56040f8ebcf89ff723c42e597b"
    sha256 cellar: :any_skip_relocation, sonoma:         "9d911968a80d3d16427d40ebab7d882da069d7776ce4eb766e78a4b4305bbf3e"
    sha256 cellar: :any_skip_relocation, ventura:        "150500d10120f6dfc71eebb0cb1b6e8d7731451a38ddb88bccec0ecbc717e2ed"
    sha256 cellar: :any_skip_relocation, monterey:       "c3617d71becfe2ef2161a9d05d43a94166cb69a9c868fd5fff5e5985c6efd213"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e1155a91a2a1aa136d2f26c063eeda396555f6a520762d453b383655e19a1cb"
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

class Lstr < Formula
  desc "Fast, minimalist directory tree viewer"
  homepage "https://github.com/bgreenwell/lstr"
  url "https://github.com/bgreenwell/lstr/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "9a59c59e3b4a0a1537f165a4818daa7cf1ee3feb689eaf8c495f70f280c3e547"
  license "MIT"
  head "https://github.com/bgreenwell/lstr.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a145541e3eb562c02740fd457f3cd5a603b77718ffd570571ff2ea5fbb047e4a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96fdc1f49bacf56b1caef9a24869aa968240b58f1ee3c67101d77de66987e55c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c459cdc51f312f8dc5848af81d469484b43d7f9eb9501836f0ea3723c03f400"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa3ae1d10d7ca531c029c10588c96e8cd0a02d308cd0b3c77112f45843481397"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "60eff494111d095ffee7343cba34dfb34a26e6aac7bb3fa7bf1108d2b4b0cd13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02ce861934304a640142f38b36bc5c1e523f4235766579e6cbac10bc17793b55"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lstr --version")

    (testpath/"test_dir/file1.txt").write "Hello, World!"
    assert_match "file1.txt", shell_output("#{bin}/lstr test_dir")
  end
end

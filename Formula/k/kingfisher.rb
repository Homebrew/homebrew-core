class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://github.com/mongodb/kingfisher/archive/refs/tags/v1.53.0.tar.gz"
  sha256 "7d2ebf592e03c6643e1b26a30fff7a6291a8d8a9e031d4342232bb0887aa5fe4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a6553b34aa1afbbed7fe6eab53a05aad3b02ea4ffd6eae528374bd668ec48011"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66fdf518a33a784fc673bb7ac7e49c9fe6fefb6486d0ca422969f82f1161168e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9857af15eb2c0f8884b8fd0f3fb1e0a8fcb1a6fc956ec3243a405385a5c9697"
    sha256 cellar: :any_skip_relocation, sonoma:        "409867af7be4875790f96b448541b6ce36d9d03588ae37f3aa7994efefd18a90"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ae4800767a506e79bcb81b93a8743b0d99c875e3ceac87b6676310e15ae6936"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56f2a1bcf99710874b55d4098fe97b9af13c31918166a8c56b4575b2fb6fe2d8"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  def install
    system "cargo", "install", "--features", "system-alloc", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/kingfisher scan --git-url https://github.com/homebrew/.github")
    assert_match "|Findings....................: 0", output
  end
end

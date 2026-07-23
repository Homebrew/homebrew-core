class Dra < Formula
  desc "Command-line tool to download release assets from GitHub"
  homepage "https://github.com/devmatteini/dra"
  url "https://github.com/devmatteini/dra/archive/refs/tags/0.10.2.tar.gz"
  sha256 "40881a16141ee9d45441ebd2db4b43d8ac664b84adbec17ce39f344763b1b415"
  license "MIT"
  head "https://github.com/devmatteini/dra.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bff093245806a47ecc544261c3b5d5dabb9da4b79a7c7f606c3be55d3823a22e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bcc34521ad30d2e4971b14543d3f55dabedd8db11c9915b21d0308d5251ed1fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83d71d1076201394b03c1cc7e1444d6048e7a6af416d4654cdbdc42be45c99b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "aef442a27ea6af8d8a1f230a7959fc5822ed6daa45392739b6438191779842d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc12b0aae855281e0b0b6f693386edbcd936fa118f128aef8daeb56a9001e3d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c72e64a3b0d2c14bcd6910e9ff97ebbb98fe4fec20fcd99aed2050b381efa64"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"dra", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dra --version")

    system bin/"dra", "download", "--select",
           "helloworld.tar.gz", "devmatteini/dra-tests"

    assert_path_exists testpath/"helloworld.tar.gz"
  end
end

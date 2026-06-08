class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://aube.en.dev"
  url "https://github.com/endevco/aube/archive/refs/tags/v1.18.1.tar.gz"
  sha256 "3b1d056cbe41022a053c857d04cd0c349fdbc7ae2f719f3b41995196c6b542a2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8278307655c687af4906ba6d907c65f4e0ce6a20f2af0b441bda7b4ee253f020"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "377f8a9554e1cc4404a5ef44d419cc0c255f4ae35cafc2928d464ca481e3c5d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "047c302e702d7131c26cbaa1fb6aa9eada68f6a284e85bd4d97dcfd866bc7fc6"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3e9e3a5ccbcba476102b971bf1dbc7a3acd64d91813bd31ac6b68e362edadc1"
    sha256 cellar: :any,                 arm64_linux:   "8ceb53d029a4ba0e12fc7d62b738a4b59b812c484e668d8f74024c663a36572b"
    sha256 cellar: :any,                 x86_64_linux:  "d372cb340e2c37dd52d2290e6403826f4fe51f447c47793cfd2b0c99271d21bc"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "usage" => :build
  depends_on "node" => :test

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/aube")
    generate_completions_from_executable(bin/"aube", "completion")
  end

  test do
    system bin/"aube", "init", "--bare"
    system bin/"aube", "add", "cowsay"
    assert_path_exists testpath/"node_modules/cowsay"
    assert_match "< moo >", shell_output("#{bin}/aubx cowsay moo")
  end
end

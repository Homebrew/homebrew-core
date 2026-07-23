class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://aube.en.dev"
  url "https://github.com/jdx/aube/archive/refs/tags/v1.32.0.tar.gz"
  sha256 "b55b6bce1acdab8e2b42add8d5dfc0789e3b6adbb2c7b190470c663c23515da8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6068bacd6df68111bf9e6695fdc5c5fba1562b5fc8d3823fece2970d43c4be2e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb7e97928aac198727c0229eed6a0e437fcb12bd12bec7dd1b2fd04603735208"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0aa8ea4d67714e7ef1e0c3cbc23584aa448447c0718d012d9d29bcd8e34244e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "c1a99ff203054a3c6948a6f95fd47a67d6c5d86340c627fe1f3041742a6b7a92"
    sha256 cellar: :any,                 arm64_linux:   "4186a3c9592ecf2740fd4165f523f0ec00e5e22907dbe78ef7779f33ce677489"
    sha256 cellar: :any,                 x86_64_linux:  "8c457325b2936d6c365625d2d65d54c8e93874a4ed613dd37f6f81121aa126a5"
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

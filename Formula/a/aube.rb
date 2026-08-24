class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://aube.en.dev"
  url "https://github.com/jdx/aube/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "a6772070e66399a400d942f8ee4fab3ea0babe02fa97f3a4eb255ce776172415"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5cac9d96f0b36ab62d292e29cf33ccf97fdf2f8c94faeb679a336ba8814dbaae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "915a3ad357d407b5d57c96bf95adeef420f72f203499f15070d89bbdbb67a7b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "496e196b42d4d83be879d5c941b60305b0f01323f42a0de4dd05773b2783e744"
    sha256 cellar: :any_skip_relocation, sonoma:        "4257b1b4f2abcccf4107c49334bfcfe2dcb91cc9710e997731cc3b1326df27fd"
    sha256 cellar: :any,                 arm64_linux:   "d4fc4d3aad269a6a9745405b48247a3695a021fe83ec10908edfe51550a0c13e"
    sha256 cellar: :any,                 x86_64_linux:  "531eee028c97bd09ce608114a8439d7891ee80cd98817ef0b9a2bb6f79473495"
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

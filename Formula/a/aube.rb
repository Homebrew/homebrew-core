class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://aube.en.dev"
  url "https://github.com/jdx/aube/archive/refs/tags/v1.41.0.tar.gz"
  sha256 "9e475ba08bdbac245337fdeb32d3385095c2c0b0b82480032fc92996f3e56de4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "718117c8e58e350eceeea04fe805239ba020c4f90c1b41709fb4f67275f37f26"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8434f152b819c965bcfd6c2185c56534e4c97c28e55df30c767af415a0b8145"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b14ae35ac6828a291d9c68276cb3c60bfb98374100b533b365d624a6a04afaf2"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f1f7f80debf0062a9c751e84818d0e64f3b377561dc86cc464335dfdb1b23db"
    sha256 cellar: :any,                 arm64_linux:   "1dfcf540f84b4e30f46eeec3cf1e730f910f692ae3751d76991f0917c2ae897d"
    sha256 cellar: :any,                 x86_64_linux:  "3ee5db77136e2bb67e10e877d9635b93885af625d152d19575b4a6a092cadf0a"
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

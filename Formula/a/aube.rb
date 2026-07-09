class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://aube.en.dev"
  url "https://github.com/jdx/aube/archive/refs/tags/v1.26.0.tar.gz"
  sha256 "114154f539e6e24e2d08102d9e37885b57d66130f3bc3085b1d095539ad4ea83"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e54ab61caec7278573d0f9d31d26f87f518af49dce9ba47635195d3b0a1573e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d1824171c1188528312dceea8ca530a2572bd052900656eb19a70255ad4bfe1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd46f974c2ea3c4000f89052932a026202d97411002808e5b5eb0a0ba9f6ffbf"
    sha256 cellar: :any_skip_relocation, sonoma:        "01169a91c0bcd20c3dc62437222207a044e7097122971769a882f1720379a843"
    sha256 cellar: :any,                 arm64_linux:   "0ae8d1edbe2c636c63c867d3282c0543f9499a8d5fb5cde8c80c0276ea52e1d5"
    sha256 cellar: :any,                 x86_64_linux:  "3cd4097e4b479742f3f08284586a36c719bf25f08d2fe790aba98e532cbf4f98"
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

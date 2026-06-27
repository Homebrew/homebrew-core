class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://aube.en.dev"
  url "https://github.com/endevco/aube/archive/refs/tags/v1.25.1.tar.gz"
  sha256 "6efc7d07dbb58ce01a7f91117a76461c718b1248bc60ec87f5a37ecec7214cf2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "81de02215c5d20a9a3b39d99f3fab167a0d2792284ed56eb1267fd1c87fdc9a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e53b72ef9ccb97e209092f1656c1f6ecc1341ecfd264ee3932761a8e241b8385"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60ad55414f7c39a114d0c9bbf1f4eaf81f64066ffae24e21b521622c136da9f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b818f24765e9b88dccb2419ac5971de314eea50e93e64cbc715a049a38bee05"
    sha256 cellar: :any,                 arm64_linux:   "66bd577ca03c9e7ee462b4d6eaf99c025057a958f63ce459f0a1bbbc9237bbf1"
    sha256 cellar: :any,                 x86_64_linux:  "c9730106a6f42897729c5025141be505aee7a5f0fd579c1922fa790422a43511"
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

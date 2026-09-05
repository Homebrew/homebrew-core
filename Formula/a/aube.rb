class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://aube.en.dev"
  url "https://github.com/jdx/aube/archive/refs/tags/v2.2.11.tar.gz"
  sha256 "2700339f9a97927e98063ccf1be77e24d966c9f6a72e43c3c73f9025e76484c8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "407bea3f6d9199314cebe7e28d653b1393eaa59aa4ae306a00bea6083f0a8693"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37052b925f05d78060fc15c3eca98261a4bcc0d55acc4cf4f172dcea45ef9f3b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a658405fb93b55b25fe6173f25e83eb5514bde5878df9106025838ea4b81005"
    sha256 cellar: :any,                 arm64_linux:   "0a427a3fa76c9eee0ff6f59cdad546b6c946fd0108c368a1c70037aad04cfd29"
    sha256 cellar: :any,                 x86_64_linux:  "6ef684f586900e2f5370d408c77d322a6adc35e36317ec99521e38f4d3a4c14f"
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

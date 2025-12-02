class Lune < Formula
  desc "Standalone Luau script runtime"
  homepage "https://lune-org.github.io/docs"
  url "https://github.com/lune-org/lune/archive/refs/tags/v0.10.4.tar.gz"
  sha256 "151b7b738b210920297b8afa560f440877662e02a48c64c28ce95baaefc96c95"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ecf1f37ac7dd78b1aabff316ac9b558ca85f692f4c5a6e2a7f814df1c0b0c9ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be6a59a97e35371fc0f7a65d189079bf412eab50f199ea2313433eb069760dd2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "305e3a1e29a8820812986cf37d5251bf7096a807134c231c61a0486570f49570"
    sha256 cellar: :any_skip_relocation, sonoma:        "d76f0677aa4a5a49c75b865635043345ce784a943d58ff8e6765c5f4290a0106"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0ca4209df72a72a008f0f3d0adb7e36afd3633d2cd19f02d3cf26a6d29412b7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2fe2d764d9a8461e9708528ae0f2899f68558a83eafb149211df8a78af61a0b7"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", "--all-features", *std_cargo_args(path: "crates/lune")
  end

  test do
    (testpath/"test.lua").write("print(2 + 2)")
    assert_equal "4", shell_output("#{bin}/lune run test.lua").chomp
  end
end

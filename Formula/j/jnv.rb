class Jnv < Formula
  desc "Interactive JSON filter using jq"
  homepage "https://github.com/ynqa/jnv"
  url "https://github.com/ynqa/jnv/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "88462d1a8dbb2a362a594d09c75b52d5798124981c9924ae7cff704e213b24f4"
  license "MIT"
  head "https://github.com/ynqa/jnv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e15f5c54af7a1adb674d21e6fedf227aed2120749b7220f3bf04c5af66b4ee3f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2a5848f6388855039fac36451406ccfe402e8b366c1e51e218f9bd9a679440d9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9a287a8a7fa860dc6229cb2284a549266c426c874e459ea2808e15dc21568f1"
    sha256 cellar: :any_skip_relocation, sonoma:         "27676c6754ba27df10748d59700582513f4bf42a1842a309eb76f3820b434d33"
    sha256 cellar: :any_skip_relocation, ventura:        "520081042e5315dac739fc8cfbb89178474d4f7c12a37f896637cdcf12516475"
    sha256 cellar: :any_skip_relocation, monterey:       "6106bb0500fc2de37af637e4d4438bc3e6dc402c34c4f29e8bf28e6c942fcb03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5aca9c959f02aa0e6e1457bba747e59de193014e7be626d65bc924df3cc79e71"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "llvm" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output(bin/"jnv --version")

    output = pipe_output("#{bin}/jnv 2>&1", "homebrew", 1)
    assert_match "Error: expected value at line 1 column 1", output
  end
end

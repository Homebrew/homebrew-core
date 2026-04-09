class FennelLs < Formula
  desc "Language Server for Fennel"
  homepage "https://git.sr.ht/~xerool/fennel-ls/"
  url "https://git.sr.ht/~xerool/fennel-ls/archive/0.2.3.tar.gz"
  sha256 "80cba4a35873d0cb112e5aebc62bf616d07ab7c42d49bf032a8c3b04da9a121f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "914bcad01ae125175f9370e5abbdc3e043ab0e90f2a29680971bd20e654b28ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "914bcad01ae125175f9370e5abbdc3e043ab0e90f2a29680971bd20e654b28ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "914bcad01ae125175f9370e5abbdc3e043ab0e90f2a29680971bd20e654b28ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "914bcad01ae125175f9370e5abbdc3e043ab0e90f2a29680971bd20e654b28ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "914bcad01ae125175f9370e5abbdc3e043ab0e90f2a29680971bd20e654b28ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6404a2fde8770bd42bf773d331a2745506137bfd5bcad021febe2f6078078a5f"
  end

  depends_on "pandoc" => :build
  depends_on "lua"

  def install
    system "make"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fennel-ls --version")

    (testpath/"test.fnl").write <<~FENNEL
      { foo }
    FENNEL

    expected = "test.fnl:1:6: error: expected even number of values in table literal"
    assert_match expected, shell_output("#{bin}/fennel-ls --lint test.fnl 2>&1", 1)
  end
end

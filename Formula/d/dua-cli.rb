class DuaCli < Formula
  desc "View disk space usage and delete unwanted data, fast"
  homepage "https://lib.rs/crates/dua-cli"
  url "https://github.com/Byron/dua-cli/archive/refs/tags/v2.29.2.tar.gz"
  sha256 "76ebd07c4a4379ef0d45232fa7a9b0bcbff1bd54fad6930ec1a2823806473f5d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "d1f2ac0323c3cdd2b0fd1a73258aa92fbd5d6a61203c8bf6bac397b753502a21"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c6315c330f498adf21af96cefdea1379c4c4ca76358313e5bdd149f2ef1414b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cbde1b93530be443c633064f54b88ea1bd4300c6421f9d4e07a9fa261b6d4d25"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f6285c35ec4e40ab0c527423281aefb23a01da48261b3addbf52160581e3ce4"
    sha256 cellar: :any_skip_relocation, sonoma:         "5db8cbece8a85105dfe10829aebeb7e6f162a594d8f583a48747527977a9427a"
    sha256 cellar: :any_skip_relocation, ventura:        "511dd96b9972a6fc336e8472a3beb8f36499a833a33c96398dd7f3ecfba07912"
    sha256 cellar: :any_skip_relocation, monterey:       "23746a4974aa193874e1990253cbfb2aeb9ba5e93b7cbc6300f6425cfe6c1ec9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ca1287b4653e96f3af3b2406a8e389a3e1d13396533044cc319f34d2a8c74a2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Test that usage is correct for these 2 files.
    (testpath/"empty.txt").write("")
    (testpath/"file.txt").write("01")

    expected = %r{
      \e\[32m\s*0\s*B\e\[39m\ #{testpath}/empty.txt\n
      \e\[32m\s*2\s*B\e\[39m\ #{testpath}/file.txt\n
      \e\[32m\s*2\s*B\e\[39m\ total\n
    }x
    assert_match expected, shell_output("#{bin}/dua -A #{testpath}/*.txt")
  end
end

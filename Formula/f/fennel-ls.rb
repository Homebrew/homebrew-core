class FennelLs < Formula
  desc "Language Server for Fennel"
  homepage "https://git.sr.ht/~xerool/fennel-ls/"
  url "https://git.sr.ht/~xerool/fennel-ls/archive/0.2.2.tar.gz"
  sha256 "38b5e45098f3f317d2c45a2898902795b18c6801577016df9151e54721bb667a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d1662af687fab82378d2a7a6defa17eaecdd45f5d2fe1fdb96ad3d54b4b0f915"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d1662af687fab82378d2a7a6defa17eaecdd45f5d2fe1fdb96ad3d54b4b0f915"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1662af687fab82378d2a7a6defa17eaecdd45f5d2fe1fdb96ad3d54b4b0f915"
    sha256 cellar: :any_skip_relocation, sonoma:        "d1662af687fab82378d2a7a6defa17eaecdd45f5d2fe1fdb96ad3d54b4b0f915"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d1662af687fab82378d2a7a6defa17eaecdd45f5d2fe1fdb96ad3d54b4b0f915"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5cc1f870f47958e1b37446c8d34fd59598562b068e398ad006150b1519e3728f"
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

class EditorconfigChecker < Formula
  desc "Tool to verify that your files are in harmony with your .editorconfig"
  homepage "https://github.com/editorconfig-checker/editorconfig-checker"
  url "https://github.com/editorconfig-checker/editorconfig-checker/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "ecc26b1c83b8d2df1c8a46b2cf5e5f2a7bfe8b530c00e9344fdfb11d8343ffcd"
  license "MIT"
  head "https://github.com/editorconfig-checker/editorconfig-checker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "43966986aa94821818726dd456caa889c77a2c5d9f6d8698d80bfd6059ae1635"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "43966986aa94821818726dd456caa889c77a2c5d9f6d8698d80bfd6059ae1635"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "43966986aa94821818726dd456caa889c77a2c5d9f6d8698d80bfd6059ae1635"
    sha256 cellar: :any_skip_relocation, sonoma:         "20470e47d0e9da292dfb756dbbe768b153f530d1825c490dfa2f406d87b2e41e"
    sha256 cellar: :any_skip_relocation, ventura:        "20470e47d0e9da292dfb756dbbe768b153f530d1825c490dfa2f406d87b2e41e"
    sha256 cellar: :any_skip_relocation, monterey:       "20470e47d0e9da292dfb756dbbe768b153f530d1825c490dfa2f406d87b2e41e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0edbd9ac928bf3e13c882cc0e0cd7d6bc4b4fc6325118bebd3c67517abb8d3bf"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/editorconfig-checker/main.go"
  end

  test do
    (testpath/"version.txt").write <<~EOS
      version=#{version}
    EOS

    system bin/"editorconfig-checker", testpath/"version.txt"

    assert_match version.to_s, shell_output("#{bin}/editorconfig-checker --version")
  end
end

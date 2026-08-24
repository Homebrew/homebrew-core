class KeepSorted < Formula
  desc "Language-agnostic formatter that sorts selected lines"
  homepage "https://github.com/google/keep-sorted"
  url "https://github.com/google/keep-sorted.git",
      tag:      "v0.10.0",
      revision: "b225c42a9a8f480d760cf967d1e3a839060b242c"
  license "Apache-2.0"
  head "https://github.com/google/keep-sorted.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e73cead4020f516df5365f487ac3fea00594e851f3ae2028d679021aaa077f92"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e73cead4020f516df5365f487ac3fea00594e851f3ae2028d679021aaa077f92"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e73cead4020f516df5365f487ac3fea00594e851f3ae2028d679021aaa077f92"
    sha256 cellar: :any_skip_relocation, sonoma:        "07f17558b3d20115d036b6f8526686e3049bb8b4b5e312a25a3d21976b3f393f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6038d02b048fd38fbbe0000527f6ba5410f67981a8d19a4bcf3ac1ceb943d201"
    sha256 cellar: :any,                 x86_64_linux:  "317e395968dd3dd01cf7d4dc52a13b00a9e6608fae47542de3762a2beede12dc"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/keep-sorted --version")
    test_file = testpath + "test_input"
    test_file.write <<~EOS
      line will not be touched.
      # keep-sorted start
      line 3
      line 1
      line 2
      # keep-sorted end
      line will also not be touched.
    EOS
    expected = <<~EOS
      line will not be touched.
      # keep-sorted start
      line 1
      line 2
      line 3
      # keep-sorted end
      line will also not be touched.
    EOS

    system bin/"keep-sorted", test_file
    assert_equal expected, test_file.read
  end
end

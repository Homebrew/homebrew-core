class KeepSorted < Formula
  desc "Language-agnostic formatter that sorts selected lines"
  homepage "https://github.com/google/keep-sorted"
  url "https://github.com/google/keep-sorted.git",
      tag:      "v0.6.1",
      revision: "3f9cf7d52cc6832a6752433472925981f89d516f"
  license "Apache-2.0"
  head "https://github.com/google/keep-sorted.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d466d5e894f29a85aba011c84521034b3617336ff4197b8212b70f31b4c8344"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d466d5e894f29a85aba011c84521034b3617336ff4197b8212b70f31b4c8344"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1d466d5e894f29a85aba011c84521034b3617336ff4197b8212b70f31b4c8344"
    sha256 cellar: :any_skip_relocation, sonoma:        "8813fb328d8ad157bdbdba961434a978838da64c12fdbffb85b9f620a322c7d9"
    sha256 cellar: :any_skip_relocation, ventura:       "8813fb328d8ad157bdbdba961434a978838da64c12fdbffb85b9f620a322c7d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9c2b478a8886f9dd91f3b696ceb74843317e782cd5f6793d9658d6f2373efbb"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
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

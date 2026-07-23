class KeepSorted < Formula
  desc "Language-agnostic formatter that sorts selected lines"
  homepage "https://github.com/google/keep-sorted"
  url "https://github.com/google/keep-sorted.git",
      tag:      "v0.9.1",
      revision: "339d935575ef7d92f2c9b4df9ce4b724d73c9201"
  license "Apache-2.0"
  head "https://github.com/google/keep-sorted.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a6cfff3839061e36c261be6510b7112928d521921b1aab39b0287623f6180c8c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6cfff3839061e36c261be6510b7112928d521921b1aab39b0287623f6180c8c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6cfff3839061e36c261be6510b7112928d521921b1aab39b0287623f6180c8c"
    sha256 cellar: :any_skip_relocation, sonoma:        "610d9d2727c3ccaef05188f4b0f59f75397c37571c2ae702fe33417c93a558a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "db7219a97d5466898e988dcced21469a44821ae3df1da2442ae21ea74ff57594"
    sha256 cellar: :any,                 x86_64_linux:  "ff08c99b116720b1ea0d0c74b471997fe872acfe148787f7afa35ea8abfc2d8f"
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

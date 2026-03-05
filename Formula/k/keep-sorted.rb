class KeepSorted < Formula
  desc "Language-agnostic formatter that sorts selected lines"
  homepage "https://github.com/google/keep-sorted"
  url "https://github.com/google/keep-sorted.git",
      tag:      "v0.8.0",
      revision: "ac58172d1655aa47a6f806e56ff0f269d6dbe637"
  license "Apache-2.0"
  head "https://github.com/google/keep-sorted.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a332a0e53eb63b14eed0fd1c573ee8eab1c1e64aed98334ca98ea011c5feb5aa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a332a0e53eb63b14eed0fd1c573ee8eab1c1e64aed98334ca98ea011c5feb5aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a332a0e53eb63b14eed0fd1c573ee8eab1c1e64aed98334ca98ea011c5feb5aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea664b552fd616f7feb5073b16df66f597cd27cffa45e4aa3d28c4c1e44ff82b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1961c31d26427ccead20527f1fc7b8da6b6aadd3c5838caf251a0d119ffba53c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eab88ac9736e72dcfc0a386d64ca5492200f5962fe136fe1d5f7db12228791f6"
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

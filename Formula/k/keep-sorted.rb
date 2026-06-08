class KeepSorted < Formula
  desc "Language-agnostic formatter that sorts selected lines"
  homepage "https://github.com/google/keep-sorted"
  url "https://github.com/google/keep-sorted.git",
      tag:      "v0.9.0",
      revision: "38613f5110f7fb5088d9ad68722e4018a11bc039"
  license "Apache-2.0"
  head "https://github.com/google/keep-sorted.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f74589767981a2f854a6232e6a06255809ba039b3a236328f2cbac6746ac9e75"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f74589767981a2f854a6232e6a06255809ba039b3a236328f2cbac6746ac9e75"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f74589767981a2f854a6232e6a06255809ba039b3a236328f2cbac6746ac9e75"
    sha256 cellar: :any_skip_relocation, sonoma:        "2dc049142b4f1919a7a9cb8b978ff8187dc0fc905f50fd737eccdb74da507581"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb31d33809850cb46ac166d05b852ac77b475b6ea3f7d3e42b2513681f0fdf20"
    sha256 cellar: :any,                 x86_64_linux:  "d02f4540fa0b53feaa7f2508fca7718c3f0881cf3e48f8edde9b8dfbc746755d"
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

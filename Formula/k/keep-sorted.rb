class KeepSorted < Formula
  desc "Language-agnostic formatter that sorts selected lines"
  homepage "https://github.com/google/keep-sorted"
  url "https://github.com/google/keep-sorted.git",
      tag:      "v0.7.1",
      revision: "c71803fd297b5736f3bfab1cfd84424ca52e961a"
  license "Apache-2.0"
  head "https://github.com/google/keep-sorted.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c83d795e7fabff68f6667cdb6d52d4dece8d68d39ed18769f3526853a12b88f2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ef6b1fa86aa500fb3c582e3b233ff8db11c930f14ecc688100278717f8fe93b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ef6b1fa86aa500fb3c582e3b233ff8db11c930f14ecc688100278717f8fe93b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6ef6b1fa86aa500fb3c582e3b233ff8db11c930f14ecc688100278717f8fe93b"
    sha256 cellar: :any_skip_relocation, sonoma:        "3bc8e596dc3996b5876eb66a9f238f63d7fcbac4b957f6e31ef68ef4863264a6"
    sha256 cellar: :any_skip_relocation, ventura:       "3bc8e596dc3996b5876eb66a9f238f63d7fcbac4b957f6e31ef68ef4863264a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1dbc70735188f2f75638db1114da4d9426eb2cd2daad450f69fe1401345d8ff5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e89740e08e8b84defbdc44674ae60df767fb0dc1cc3ba9e63037caa2c40e018"
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

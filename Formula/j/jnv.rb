class Jnv < Formula
  desc "Interactive JSON filter using jq"
  homepage "https://github.com/ynqa/jnv"
  url "https://github.com/ynqa/jnv/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "767226c67378381d1e71ffe0e631a5b5ffc00e957a05780a9b23b6a65023bb44"
  license "MIT"
  head "https://github.com/ynqa/jnv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fc43618a6dd580b20af4dd52152c1e6fee6bc781664b226fdc3117de1632bab9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "212a1eb491a041caba040a7a25619a86898f8a144ac6c8d4fdb018d842b33977"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f15e0603e1aa975615b25e194b0296b5393f8a3c33cfbd705ef3757eb021534d"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1f94e2da0507ed5fbccbce883672a77ae65434a8bbb7c2338b25595a5b5d7bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a35d5569a5c3e9d7ae07d510b76e6e074f168b2cd48586760d4ed71b9151ac1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c17cec2f694a06164ab359d4605bf21e358cdca3883da79e0cc31bf1b94800b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jnv --version")

    output = pipe_output("#{bin}/jnv 2>&1", "homebrew", 1)
    expected_output = if OS.mac?
      "Error: The cursor position could not be read within a normal duration"
    else
      "Error: No such device or address"
    end
    assert_match expected_output, output
  end
end

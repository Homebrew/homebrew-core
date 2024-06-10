class Jnv < Formula
  desc "Interactive JSON filter using jq"
  homepage "https://github.com/ynqa/jnv"
  url "https://github.com/ynqa/jnv/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "4cbb0700b3b1c4212c97edca577039abf4ea238ca8c966978825d537f13f8885"
  license "MIT"
  head "https://github.com/ynqa/jnv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3c4a4d321848c6e62f36cf921aff575d56e7e1c913a745d8b4e633e87c8cc449"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2159c5e6c9d548b28abad2ec9f2f908758ba1aa035bae21ecb4c3bfb0f42ac28"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3214aeeafa34b3cabf330b10276efd6bfabf6b86fb34aad8c716addb1a10f5d6"
    sha256 cellar: :any_skip_relocation, sonoma:         "2866a9d24e838dbfab3ffd53ed8821adef3ac1d062e4781b6bb8633d4cb1cc9e"
    sha256 cellar: :any_skip_relocation, ventura:        "13f99b3f55a70f9d23a07cac1f0a81752d06e5baa30020162daf8d5ecd639e5f"
    sha256 cellar: :any_skip_relocation, monterey:       "ebeb7b8259a4bb7f73dbe2bebee0bb5136683af0abc308cc97170e81337c4279"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9e0ea9aa4d8745b0fa0eba94c750fec760003616d5d93a82930ed6d2596209f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "llvm" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output(bin/"jnv --version")

    output = pipe_output("#{bin}/jnv 2>&1", "homebrew", 1)
    assert_match "Error: expected value at line 1 column 1", output
  end
end

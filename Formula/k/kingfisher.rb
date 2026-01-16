class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://github.com/mongodb/kingfisher/archive/refs/tags/v1.74.0.tar.gz"
  sha256 "23dccedf39261b6e3fa547ec86f3e2beae171b776dc0ebc875a7acce49c9229b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1c419cb81d504a8716da38edcc2725be891145a6d4ffda314a0bddad732ce16e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc7aad68fa047625ba59c9f983a46a511d52ea9f8a2a9ff4ab6ab980c09abc31"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0993a4d53f9f48aa1a4b4b4ce7dabf00ee0faefd4e16ebf30f8c01bf9f9800ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "983595b9d95fbadd4e7e152e73d840ba71bab2be9a79dfe4a95ef5ce9864f631"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b76aaf897ab8659f2ecfd28871bde9b3f46b775da498d1621a67e437cc69b27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07d6d32ffce699a682c087135cd99a136ff06a6b2a3167772f7c9713fda1943b"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  def install
    system "cargo", "install", "--features", "system-alloc", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/kingfisher scan --git-url https://github.com/homebrew/.github")
    assert_match "|Findings....................: 0", output
  end
end

class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://github.com/mongodb/kingfisher/archive/refs/tags/v1.75.0.tar.gz"
  sha256 "f4846351438903cf8d867b5d21d6b1877bafcc848cf26a952c5915442fc66c35"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "98b84de423c80448fd3eb4651a0e3cb4d87ae63e32259da72834efc3242f7a62"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1da02781954b4ed06e8cd6db9799221935c1ccb5cefc012c58c0cb3df55d424d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a3f6bcb940f816c103cbaadbb227e9edf94e367f227fc1411d945190f2a50a63"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c16ac1d9da5052100eca2693d84c02d496b6e50ffd75b3bbbba08fec69c557f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "869e1a10147a745e6af1e53499ece0fee1e6f2d27fed0a182ea03d8938f7faec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06703a662cbd8f93567157e45988d37a968d40ac3f3118cdc317d055e45c0b9d"
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

class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://github.com/mongodb/kingfisher/archive/refs/tags/v1.54.0.tar.gz"
  sha256 "8cf829da30dc3e4622e13bd197c7420d1c3949fe51f05b6738f3811b91035554"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8efe3bb4818dd93e968209d54fafaaee2f924002d8776148d1887ad469e1d3de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66d242ad30286f271581602f1cd4e0523130e9aba2a138b511eb493ccd0f9d55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db33cd02fc9e8f0e8c53a931c5061ad450bcb7d03a58ddcf0529103d46c342a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "62e224084a3d63a9b7306cdcaf43469771ae8a4a204f76e468c8b9dfd34ad751"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2bb33ef2fa9ae1b499c982651bd72f1dd6787ccb88e82b0ee8e9daa7504c34a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a583551d6620832c15033fd24b47ba3eb2c2437c52ae730c940147667af69b88"
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

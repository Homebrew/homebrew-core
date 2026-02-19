class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://github.com/mongodb/kingfisher/archive/refs/tags/v1.83.0.tar.gz"
  sha256 "833f98ca7e1a46c904eb29b82079be4b7de4a6bcf029f3f24bf296dba93f13a0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "405adc0391e73ec58cd49bcb2704d6172be7e55734e7d901ea4d2ab8486251c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca8fe1bc762d1627699b8b08ba33a9c2d8c2b10722f51b95234221db996335cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16de6a02808bccb9fd9a0a34d2d6d7595ba82ccf99f9a3c21c74b29ec22d2633"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1a347e662b8959e6cd470253a46b11950d53533d913d3ea9721b7b2848fd4b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ccbbe1be2ff7a65b92ea382734495bde935c1c43975d01c142576553e10ae7bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "abff7fedf9eea71ba3d3045851b03fffcb581c20f9600720644b9364b6a22c05"
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

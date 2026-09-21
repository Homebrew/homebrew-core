class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://mongodb.github.io/kingfisher/"
  url "https://github.com/mongodb/kingfisher/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "cf4ed6880d56125da6218ad79c6db263d88926236d24b67fbebb59f4a67c29bd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a3b429114dff74a6a6ae1f0cede908019b6c316d4f6decabfe01342629e27f5f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "786294b5cea8aa7a2843b8a73e665fa7683d467c14ae3efd5ef8cb67cbc9a64d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "25d3a8d27af654bad65621b2429d60eb82844fe2b085ee9dc67f55e67ae8778d"
    sha256 cellar: :any,                 arm64_linux:       "c6bd97a714138648749b4bea48218d600e5ffccbb90dec335b0a745a02a7bd2b"
    sha256 cellar: :any,                 x86_64_linux:      "1d6ee663a59744e47c244b3022bee918af7244eaa2b6fefac816d154b802f6ab"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "openssl@3" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  def install
    args = std_cargo_args
    args << "--features=system-alloc" if OS.mac?
    system "cargo", "install", *args
  end

  test do
    output = shell_output("#{bin}/kingfisher scan --git-url https://github.com/homebrew/.github")
    assert_match "|Findings....................: 0", output
  end
end

class Mcat < Formula
  desc "Terminal image, video, directory, and Markdown viewer"
  homepage "https://github.com/Skardyy/mcat"
  url "https://github.com/Skardyy/mcat/archive/refs/tags/v0.4.6.tar.gz"
  sha256 "2d192fbd561cafd275505e28e649af804add8edabeb5a48a26e474187573d420"
  license "MIT"
  head "https://github.com/Skardyy/mcat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4b540665d46e453d425a86d38af54b497cbc4a6673ad8c9f2a5d0aaf602706b1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "535975d10cb2fc90fecf6ef2baf886cb1f1a963370a47eecb5830cc23051b5ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4c1cca18b6aa665c83ca9a21968e6c06d935359d2588ce7e30db1ec11d0ada8"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e74346a135925395ed249a72bfd08f9ce8339d7b0becb916cc14729039ffdbf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0fd9fefc639638499ac67f90a0e20c6749587b434825889970f73c1600857c36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7f8a99a903865bb847e95826a7e3328e2f2f31833bc59a309b28d84a21f5346"
  end

  depends_on "rust" => :build

  conflicts_with "mtools", because: "both install `mcat` binaries"

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/core")

    generate_completions_from_executable(bin/"mcat", "--generate", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mcat --version")

    (testpath/"test.md").write <<~MD
      # Hello World

      This is a **test** of _mcat_!
    MD

    output = shell_output("#{bin}/mcat #{testpath}/test.md")
    assert_match "# Hello World\n\nThis is a **test** of _mcat_!", output
  end
end

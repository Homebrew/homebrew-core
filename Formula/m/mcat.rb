class Mcat < Formula
  desc "Terminal image, video, directory, and Markdown viewer"
  homepage "https://github.com/Skardyy/mcat"
  url "https://github.com/Skardyy/mcat/archive/refs/tags/v0.6.4.tar.gz"
  sha256 "148a37048e6aeaf3cb3e13aa107a5a8544d6bac24e24b9744dc16d075aab7ff5"
  license "MIT"
  head "https://github.com/Skardyy/mcat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1f133b96d6436c83264d87d0da0f983721b7ff0ef8fb64f1fad0df33dc3d22f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c34a7a9db89706e472280ba0d908cec88aa93b2ad6cd251fbcd1e3b41d7c4708"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70ba1ebcecce4dc8fe90a26c83e04ae576fccedda666079d2ed7597921144d81"
    sha256 cellar: :any_skip_relocation, sonoma:        "025c6b7afe154bd537d3950dfcdc82be13568c56f403928236be26b5b648acd1"
    sha256 cellar: :any,                 arm64_linux:   "e3868344dcca3c9d6f6c7487122eb64c5ea060045839c4f62bda8c15caa74837"
    sha256 cellar: :any,                 x86_64_linux:  "5f2f390d6b80d0836826f54b72359bd94338042a3483615c316bbc48efb5a190"
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

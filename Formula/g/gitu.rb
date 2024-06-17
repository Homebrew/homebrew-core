class Gitu < Formula
  desc "TUI Git client inspired by Magit"
  homepage "https://github.com/altsem/gitu"
  url "https://github.com/altsem/gitu/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "12a452b99b8e6b35aca810d093ea21fcfbacd29272eb70a72a5d67f99db7f31c"
  license "MIT"
  head "https://github.com/altsem/gitu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eef232a6c50a1a195809a73da260b65313d62694a3f540edc1ef4c2e849b218f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bcb6a8299fb0a2e9bc959e939d4e91e0f44700976b0d407ae7d6f5aa0e60a6d3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed33cefad10c621897d4a3416d42ceb4b47aaf7bb9c9d9af879b83c986b02442"
    sha256 cellar: :any_skip_relocation, sonoma:         "e91beda3a697e970a2305a0d936d03b850d1b001092e9938405a1d2ad8320eae"
    sha256 cellar: :any_skip_relocation, ventura:        "b5cd69636db663153b8cfb0037e456c98789121e0aab1ef02e76674430cd4168"
    sha256 cellar: :any_skip_relocation, monterey:       "f28f0507fca31a9082281db8ae5c2744dee0667360f9a9228325e71c9205b6a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78169daa38173e99936b131038d168d63c4c2cae7990184587ddc11d06a4ec66"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitu --version")

    output = shell_output(bin/"gitu 2>&1", 1)
    if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      assert_match "No such device or address", output
    else
      assert_match "could not find repository at '.'", output
    end
  end
end

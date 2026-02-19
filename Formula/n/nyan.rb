class Nyan < Formula
  desc "Colorizing `cat` command with syntax highlighting"
  homepage "https://github.com/toshimaru/nyan"
  url "https://github.com/toshimaru/nyan/archive/refs/tags/v1.2.5.tar.gz"
  sha256 "d3bb6223c5fe8bbba5e59ac46802b52727043bf500eb664aa4896c341321ce5d"
  license "MIT"
  head "https://github.com/toshimaru/nyan.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7e97ca9001aaf786df7e79bb8eb4f1d9dbb7ff9aadedcb1dc4d0d7fcee9faf25"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e97ca9001aaf786df7e79bb8eb4f1d9dbb7ff9aadedcb1dc4d0d7fcee9faf25"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e97ca9001aaf786df7e79bb8eb4f1d9dbb7ff9aadedcb1dc4d0d7fcee9faf25"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a814027797c17605f8002cbe8e1e2b269eac1dc44305f1d865495d52c832efd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e25e10f496c982017ae5f7274de92c9a25c8d04cfdd9a0a65ae899bd9aa6e45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef4b49a2cb88228842ce74ccc4d8820c5d1a7cede0498e09e2e8cd58908699a1"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/toshimaru/nyan/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nyan --version")
    (testpath/"test.txt").write "nyan is a colourful cat."
    assert_match "nyan is a colourful cat.", shell_output("#{bin}/nyan test.txt")
  end
end

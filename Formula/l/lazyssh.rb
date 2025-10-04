class Lazyssh < Formula
  desc "Terminal-based SSH manager"
  homepage "https://github.com/Adembc/lazyssh"
  url "https://github.com/Adembc/lazyssh/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "ada257fb07db602e92c9c2a3183f267b63fb8e1bf80c4d3292461a003aa794d5"
  license "Apache-2.0"
  head "https://github.com/Adembc/lazyssh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f0c63da9b9f68f23c8972fa6b05494629f0adaad4916935df48570e502cfa4f4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0c63da9b9f68f23c8972fa6b05494629f0adaad4916935df48570e502cfa4f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0c63da9b9f68f23c8972fa6b05494629f0adaad4916935df48570e502cfa4f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "e12e64c16498b7389dd64e0b5881a1b049247fd001410411c7b54078e6aaf476"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b82d470c3789da56de848105afdb18e99cc95ef3e3a29f884d27d96d0b8ae03c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a0b3f0e05fcca49ef5267526d22d8ad447758073a7d5b7fa29f693dd1db19d8"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0" if OS.linux? && Hardware::CPU.arm?

    # has to be `brew` for `gitCommit` due to length constraint
    ldflags = "-s -w -X main.version=#{version} -X main.gitCommit=brew"
    system "go", "build", *std_go_args(ldflags:), "./cmd"
  end

  test do
    # lazyssh is a TUI application
    assert_match "Lazy SSH server picker TUI", shell_output("#{bin}/lazyssh --help")
  end
end

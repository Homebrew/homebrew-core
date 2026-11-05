class Jj < Formula
  desc "Git-compatible distributed version control system"
  homepage "https://github.com/jj-vcs/jj"
  url "https://github.com/jj-vcs/jj/archive/refs/tags/v0.47.1.tar.gz"
  sha256 "838fb5ddbf474ccee6639ce68835cedf88c8285b5c812599c56688286fb0b7a6"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/jj-vcs/jj.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4a5c843061fd135beb9bbc2f2e311c9ea30e88e20e29c9c75a50d43e05900f97"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2203d5f7aa2f0bbd1b3798fd897e8c975a53078efaac67e8a6da81d7c5539884"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8f910a47ef794ed9cc75306042f347536424c6d49263ec380729484aef315612"
    sha256 cellar: :any,                 arm64_linux:       "ee3b3f977ea01fdae4f7561960876bc29ebb254379e276fc83acc1f76d851626"
    sha256 cellar: :any,                 x86_64_linux:      "ae80aeab653e558fe220d4be404f8752225dfecd30e2dbdf438f4e8e9a01d0e9"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")

    generate_completions_from_executable(bin/"jj", shell_parameter_format: :clap)
    system bin/"jj", "util", "install-man-pages", man
  end

  test do
    touch testpath/"README.md"
    system bin/"jj", "git", "init"
    system bin/"jj", "describe", "-m", "initial commit"
    assert_match "README.md", shell_output("#{bin}/jj file list")
    assert_match "initial commit", shell_output("#{bin}/jj log")
  end
end

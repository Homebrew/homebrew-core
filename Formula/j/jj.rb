class Jj < Formula
  desc "Git-compatible distributed version control system"
  homepage "https://github.com/jj-vcs/jj"
  url "https://github.com/jj-vcs/jj/archive/refs/tags/v0.43.0.tar.gz"
  sha256 "5d230327737ee506b716c6ae5ac824c49951c34e117a024dc7aa38819809ea6c"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/jj-vcs/jj.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fc0c360992122d43ef3f6cfc1d69f0c70658d55a59cf20f6760a9271a8445652"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d8bdc7b1bbe79227f00cb4a4ca6ca653182e5df72d3ccc23975a19cb31b24c24"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0a6582a279708aca4c7028a1b57d31d9eeece5be3d5f655b7fca3d79fe6b433"
    sha256 cellar: :any_skip_relocation, sonoma:        "3112a444e9ed8022cac2752001575cfece326a36ebfd14d681a414a712c7b994"
    sha256 cellar: :any,                 arm64_linux:   "cc276f59c07613fad51c2a5fe86bf11e44571678b11e631cb6ca257212e02565"
    sha256 cellar: :any,                 x86_64_linux:  "10df3d2b3e8eb443aedd33773b8cf4d00a2fca478c74f616c6b5a8dab66cade0"
  end

  depends_on "rust" => :build

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

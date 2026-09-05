class Jj < Formula
  desc "Git-compatible distributed version control system"
  homepage "https://github.com/jj-vcs/jj"
  url "https://github.com/jj-vcs/jj/archive/refs/tags/v0.45.1.tar.gz"
  sha256 "72bf95905a92c592dd0e7316e2cbbad9a8f2ca04ca770cc4f4f7960495a44e15"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/jj-vcs/jj.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7d0bf5e8851234e8ff04702971091c37ab63e531195f11c3bf53dc8dc36ee51b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07d5262b6c09bd46ccc805abb1eb279ff26be779442433f055d8f9570fbcb9d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f461b0f7aabe7ced9335adcfc9badc7d59454fe8709b8eae2e16ab4bc88dabed"
    sha256 cellar: :any,                 arm64_linux:   "00872c1ab64311e69ca6b43004e303592e5e68eb0a9829a080a185b24d7afb29"
    sha256 cellar: :any,                 x86_64_linux:  "f05a01b79407a47effa2de144d7ce084712343234f3b659450cc01b9af884d9c"
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

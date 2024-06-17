class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/refs/tags/v0.42.0.tar.gz"
  sha256 "50a502b44fa5d28ce046def9388c6fd3e484f678691deea64c729bfd728c7f77"
  license "MIT"
  head "https://github.com/jesseduffield/lazygit.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "51d02b3c1e2226dcf163a0aa0bc7857ae5c257c0b4b3d5a9bd1e0935c1b7e1e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a6167521dbe60a9b06726f5cb6265dc7b55c4e39e24b943c6c58160262f2db7b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fece88d6f5cdcf6b3efdc2960eb13a05cee4274a717d162a6b5a479732112dbd"
    sha256 cellar: :any_skip_relocation, sonoma:         "900a96767b08ee9f99960d5b15866d08c6eec39973cf26ad4e366bf0fa04be2b"
    sha256 cellar: :any_skip_relocation, ventura:        "1c546ef98437966baac8919640490bbd3e0f7795b6d90154e99a41a74489630e"
    sha256 cellar: :any_skip_relocation, monterey:       "e740a4edfdd5b3ed5594e6bbc1d8663d97cbc8bbe2b1f81e56e4f10c95b4d41b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "755b550869518dca3805cf5974eea17c4726be2b4279f33697167c791ad381ef"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version} -X main.buildSource=homebrew"
    system "go", "build", "-mod=vendor", *std_go_args(ldflags:)
  end

  test do
    system "git", "init", "--initial-branch=main"

    output = shell_output("#{bin}/lazygit log 2>&1", 1)
    assert_match "errors.errorString terminal not cursor addressable", output

    assert_match version.to_s, shell_output("#{bin}/lazygit -v")
  end
end

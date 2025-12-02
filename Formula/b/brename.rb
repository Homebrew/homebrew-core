class Brename < Formula
  desc "Cross-platform command-line tool for safe batch renaming via regular expressions"
  homepage "https://github.com/shenwei356/brename"
  url "https://github.com/shenwei356/brename/archive/refs/tags/v2.14.0.tar.gz"
  sha256 "a16bceb25a75afa14c5dae2248c1244f1083b80b62783ce5dbf3e46ff68867d5"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "de768e5762a8564a275a8bc3f06407d3b17e8eb22cfb7619baa517815aefa460"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39e2df7de67e853a566edaa7a2ba0f092013367b2efcea51d3c5c5d311b8fd94"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39e2df7de67e853a566edaa7a2ba0f092013367b2efcea51d3c5c5d311b8fd94"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "39e2df7de67e853a566edaa7a2ba0f092013367b2efcea51d3c5c5d311b8fd94"
    sha256 cellar: :any_skip_relocation, sonoma:        "b8b913eb74ec7ad4a0173416d14bbf3b0778e4cfcfbab96074d23f3dc3eb599e"
    sha256 cellar: :any_skip_relocation, ventura:       "b8b913eb74ec7ad4a0173416d14bbf3b0778e4cfcfbab96074d23f3dc3eb599e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "170e7aab9d87ab1c8f1d8dfc8fdf21e50317f6de279a87e41fe0c1f3da895b49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a2f5be698351339e8d38e1f6c0349a527c16bba384f8af516b732d4dc0330af"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(tags: "netgo", ldflags: "-s -w")
  end

  test do
    (1..9).each do |n|
      (testpath/"Homebrew-#{n}.txt").write n.to_s
    end

    system bin/"brename", "-p", "Homebrew-(\\d+).txt", "-r", "$1.txt", "-v", "0"

    (1..9).each do |n|
      assert_equal n.to_s, (testpath/"#{n}.txt").read
      refute_path_exists testpath/"Homebrew-#{n}.txt"
    end
  end
end

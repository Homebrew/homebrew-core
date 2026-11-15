class Brename < Formula
  desc "Cross-platform command-line tool for safe batch renaming via regular expressions"
  homepage "https://github.com/shenwei356/brename"
  url "https://github.com/shenwei356/brename/archive/refs/tags/v2.15.0.tar.gz"
  sha256 "ad957eea95c7b1f8283a08c46f7128e0f944d29e139bf63557da17f1906b47df"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2212ccc939cbfe057695a0162921a22598766d7cd89de84a36f6349a6de9a3d1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2212ccc939cbfe057695a0162921a22598766d7cd89de84a36f6349a6de9a3d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2212ccc939cbfe057695a0162921a22598766d7cd89de84a36f6349a6de9a3d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b6907fee4844568207c80cdc6a387a45b3bf505b26511b6d863e866b787af24b"
    sha256 cellar: :any,                 x86_64_linux:      "51a77ae555f60537d7317ee02d4f59ebb0d34696fa102302c6050954da1034d3"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(tags: "netgo")
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

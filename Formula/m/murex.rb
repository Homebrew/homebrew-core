class Murex < Formula
  desc "Bash-like shell designed for greater command-line productivity and safer scripts"
  homepage "https://murex.rocks"
  url "https://github.com/lmorg/murex/archive/refs/tags/v7.0.2107.tar.gz"
  sha256 "b1abdd6e28be3e4c62f0690c50658e6a823788dcf704707e0e652ba1d80cd4a7"
  license "GPL-2.0-only"
  head "https://github.com/lmorg/murex.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6fb444e047917a8161518848784d9f5ae58462c6b2ddf8774d842c25b92670f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6fb444e047917a8161518848784d9f5ae58462c6b2ddf8774d842c25b92670f2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6fb444e047917a8161518848784d9f5ae58462c6b2ddf8774d842c25b92670f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "589457c8c7503101910ae5b0ec181ed09d58e4e6d076d4dd66838d06ccdbee8e"
    sha256 cellar: :any_skip_relocation, ventura:       "589457c8c7503101910ae5b0ec181ed09d58e4e6d076d4dd66838d06ccdbee8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4b0ae3c7eea4d5da28c711a84cce0fe4401a368f0cd64157bb62211e5acf002"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_equal "homebrew", shell_output("#{bin}/murex -c 'echo homebrew'").chomp
    assert_match version.to_s, shell_output("#{bin}/murex -version")
  end
end

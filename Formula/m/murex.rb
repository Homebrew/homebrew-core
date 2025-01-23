class Murex < Formula
  desc "Bash-like shell designed for greater command-line productivity and safer scripts"
  homepage "https://murex.rocks"
  url "https://github.com/lmorg/murex/archive/refs/tags/v6.4.2063.tar.gz"
  sha256 "e980fdb8d822bf9ad8f26aa412b2771bdf154561e2dba4c30cc040db19232dd2"
  license "GPL-2.0-only"
  head "https://github.com/lmorg/murex.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef6be22c52e53857cd33246c1c5e9232f762005db6b19583d8baef15f1a64c2b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef6be22c52e53857cd33246c1c5e9232f762005db6b19583d8baef15f1a64c2b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ef6be22c52e53857cd33246c1c5e9232f762005db6b19583d8baef15f1a64c2b"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e82a5cb3b5b6e410012c8c2d8d2488f96996586cdfbfc0c18e4b9c6071d5844"
    sha256 cellar: :any_skip_relocation, ventura:       "7e82a5cb3b5b6e410012c8c2d8d2488f96996586cdfbfc0c18e4b9c6071d5844"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "839235b629a4335b65bd919e1d1e1d1b0671490bda7282bec06881f3da09bc63"
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

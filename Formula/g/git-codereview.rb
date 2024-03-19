class GitCodereview < Formula
  desc "Tool for working with Gerrit code reviews"
  homepage "https://pkg.go.dev/golang.org/x/review/git-codereview"
  url "https://github.com/golang/review/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "15e4cdbf6fe07c2f1c46748e6aba48d1d1f5203c1ca10950ea6877defb39fa19"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1f432d46492d763a5a1d72a5461b1062172d89ab5a661c4eccc486f7def7cd59"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "28d7afbd5d05a2c1eeab4d3ac768c720cd238b4fae2fa982e929fb103eb131a1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b18cc30d154ad2cf58cd0a9d8be2af636916027e39f04353d096ff814be824b"
    sha256 cellar: :any_skip_relocation, sonoma:         "659a29cab581c68a089fcc16912f44efb797879a39aa2b1f9e2811977a4b40a8"
    sha256 cellar: :any_skip_relocation, ventura:        "b2995bb68539cd08525b5872b1d7d4b6bc3f08a688cd880757c24ae61bb01c13"
    sha256 cellar: :any_skip_relocation, monterey:       "d9dc9b4f5b4ea91c8cd3a12fbc33b46327338867860b0e70f605d8ae95ae617f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1cb2a7f761a54a67df8147c9d45008f8363442867d6c7b999ffd6529c0429ae"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./git-codereview"
  end

  test do
    system "git", "init"
    system "git", "codereview", "hooks"
    assert_match "git-codereview hook-invoke", (testpath/".git/hooks/commit-msg").read
  end
end

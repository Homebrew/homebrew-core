class Murex < Formula
  desc "Bash-like shell designed for greater command-line productivity and safer scripts"
  homepage "https://murex.rocks"
  url "https://github.com/lmorg/murex/archive/v2.6.0520.tar.gz"
  sha256 "0c29e423bb82ea035d059efc835522018e4f59bbeb9e61e5bcc2e812daa875bc"
  license "GPL-2.0-only"
  head "https://github.com/lmorg/murex.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ab31b72ecf11ccec9e867e2b137634deb117f524c14022c57daea1b9381e5d1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f1ea8af7c6205fa3def8a1b7326643c16e463a620464aba4163e70aec54b69e3"
    sha256 cellar: :any_skip_relocation, monterey:       "970a5db4b2bf31753e0595fa12b5c03aa3abae4707b8c3b86dd737f2747d0d8e"
    sha256 cellar: :any_skip_relocation, big_sur:        "54a24eda24231bcf1d01c8a5f48ce735970c2bb7a6991228628a201df085ebab"
    sha256 cellar: :any_skip_relocation, catalina:       "7331c51b4bf57a041bd92184833ce9341e31f824461e5aa4da22c3a4ab6e3ed0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "748258013479a5897e7f86c84729ff81bb9e2d76cf62c32df6d908505d3b173b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system "#{bin}/murex", "--run-tests"
    assert_equal "homebrew", shell_output("#{bin}/murex -c 'echo homebrew'").chomp
  end
end

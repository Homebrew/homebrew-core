class Cpanminus < Formula
  desc "Get, unpack, build, and install modules from CPAN"
  homepage "https://github.com/miyagawa/cpanminus"
  url "https://github.com/miyagawa/cpanminus/archive/1.9019.tar.gz"
  sha256 "d0a37547a3c4b6dbd3806e194cd6cf4632158ebed44d740ac023e0739538fb46"
  # dual licensed same as perl (GPL-1.0 or Artistic-1.0)
  license "GPL-1.0"
  head "https://github.com/miyagawa/cpanminus.git", branch: "devel"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c279cbdfa489e4b0be72e46a8e325fc4f8070ff83c7d78026e7b7c5831e3678d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "78c0fc8d2fcb14cb94e62d972f06ae6a1762846471eb5d0669909121c24fa08d"
    sha256 cellar: :any_skip_relocation, monterey:       "7859de46dbe67b3c9375bd8e3de6519d75f3c69a8d3698d3bb22d6163452ab39"
    sha256 cellar: :any_skip_relocation, big_sur:        "6a9b5bde63d8c5860788c67470c9dffcfe12036d38e331ad4c5028455ad45a79"
    sha256 cellar: :any_skip_relocation, catalina:       "6a9b5bde63d8c5860788c67470c9dffcfe12036d38e331ad4c5028455ad45a79"
    sha256 cellar: :any_skip_relocation, mojave:         "6a9b5bde63d8c5860788c67470c9dffcfe12036d38e331ad4c5028455ad45a79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78c0fc8d2fcb14cb94e62d972f06ae6a1762846471eb5d0669909121c24fa08d"
  end

  def install
    cd "App-cpanminus" do
      bin.install "cpanm"
    end
  end

  test do
    system "#{bin}/cpanm", "Test::More"
  end
end

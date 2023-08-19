class Ksh93 < Formula
  desc "KornShell, ksh93"
  homepage "https://github.com/ksh93/ksh#readme"
  url "https://github.com/ksh93/ksh/archive/refs/tags/v1.0.6.tar.gz"
  sha256 "bcb230cb3cbe045e0c08ed8d379fb4e1b434784bb0aab0e990c51a03e63d6721"
  license "EPL-2.0"
  head "https://github.com/ksh93/ksh.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "99a2a912374d3ed6719aa4b5550bf3c45907766a104213a3935f074fb5c76ccd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d8988a76dba906d6240b26fc41b0bd1befd78ec2c356a47472ac44a2a8b17d8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f264566bab99d740910710686ff2cdd65b80d6a31a5046c7aa6b1f1c09d69527"
    sha256 cellar: :any_skip_relocation, ventura:        "4923534c98ae8e24c40ccb852aa82e0298d3406cd41eaf541544b9892e24dff2"
    sha256 cellar: :any_skip_relocation, monterey:       "e009dfe1425f226ec4ebd0eecbf430c5784cb00d32ef0063ce1e2ad813bb2461"
    sha256 cellar: :any_skip_relocation, big_sur:        "07a2dc2b1aa2e3c8f061d5da3604b6ed3a0554f47de7c5ed1e3b4fde60c07caa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4dde2a02e972428a7cf9f8b9ba285de8be8e3386dfeba21206da66f920565c9"
  end

  def install
    system "bin/package", "verbose", "make"
    system "bin/package", "verbose", "install", prefix
    %w[ksh93 rksh rksh93].each do |alt|
      bin.install_symlink "ksh" => alt
      man1.install_symlink "ksh.1" => "#{alt}.1"
    end
    doc.install "ANNOUNCE"
    doc.install %w[COMPATIBILITY README RELEASE TYPES].map { |f| "src/cmd/ksh93/#{f}" }
  end

  test do
    system "#{bin}/ksh93 -c 'A=$(((1./3)+(2./3)));test $A -eq 1'"
  end
end

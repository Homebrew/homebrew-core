class Ksh93 < Formula
  desc "KornShell, ksh93"
  homepage "https://github.com/ksh93/ksh#readme"
  url "https://github.com/ksh93/ksh/archive/refs/tags/v1.0.5.tar.gz"
  sha256 "940d6dd6b4204f4965cf87cbba5bdf2d2c5153975100ee242038425f9470c0fe"
  license "EPL-2.0"
  head "https://github.com/ksh93/ksh.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "34a7e6e827f9190fd87729f21dd5e961cfdb1c4d831a37b5a273009b6ad741ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e25ee59b49284c57d26e768136e0c45d656d25ba0d66837d6e9aee920933068f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e7822cb9d801b5f6035dba2829748e34686ba787342ad2a29e433cd4b270c47c"
    sha256 cellar: :any_skip_relocation, ventura:        "491a98e27116801e211e2ca7dfb1a3d11ec2968e2011dd1f1ad6eb7442d9a6d6"
    sha256 cellar: :any_skip_relocation, monterey:       "bd356221b4d74a37d498a15183f5537d0d8d6c91b56c2b6321b774c1984d56f5"
    sha256 cellar: :any_skip_relocation, big_sur:        "83693c52f6a7ae0ef3d0e893acd4b5b08bcc0035b79b89128bc5d3191bc40f48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4d3d98626fd8e898eae39f1983063b4522a61be97ac8a762ca05f95ddfe898e"
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

class Ksh93 < Formula
  desc "KornShell, ksh93"
  homepage "https://github.com/ksh93/ksh#readme"
  url "https://github.com/ksh93/ksh/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "e554a96ecf7b64036ecb730fcc2affe1779a2f14145eb6a95d0dfe8b1aba66b5"
  license "EPL-2.0"
  head "https://github.com/ksh93/ksh.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "327136e79b926b47b57db0187fb4ab29a7ebf25530830c16cb6d5a4ad3dab16a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d5ed074d053386decffbb819de89ceae91b51e1abc18b5bf2fd330a1183ea4fb"
    sha256 cellar: :any_skip_relocation, monterey:       "f964e045dfc7d1e037d313d61fefa154b4b3eafa0a6b7d9c339ca21080b4c8ec"
    sha256 cellar: :any_skip_relocation, big_sur:        "d30e23da09505e4bf2a02edcd7cc63d00c9662467e32c153afecec25fae1e688"
    sha256 cellar: :any_skip_relocation, catalina:       "d50a7df0e90a3662f01951ebdec512a3a452d1c3e927a594f920b293a7bc3368"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f56ab0571fe27f19aa9c8cd9359ac75c5ded35d2333ba60c91780ed5395f854f"
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

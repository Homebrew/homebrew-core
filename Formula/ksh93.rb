class Ksh93 < Formula
  desc "KornShell, ksh93"
  homepage "https://github.com/ksh93/ksh#readme"
  url "https://github.com/ksh93/ksh/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "e554a96ecf7b64036ecb730fcc2affe1779a2f14145eb6a95d0dfe8b1aba66b5"
  license "EPL-2.0"
  head "https://github.com/ksh93/ksh.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "82aebd246ccc2a9d270444e04a9f29873a2772672ec6f829985686b689a57010"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3410ce72715108117baae0957593aad197012a99e9d12da2f01d824c1d555006"
    sha256 cellar: :any_skip_relocation, monterey:       "241bdbd27bda1bfa2a2e5bf792bdd5512d6994b436a832704363719b204049f5"
    sha256 cellar: :any_skip_relocation, big_sur:        "d6d5a36fc9811cc9e11107b03b2a9f579d2e8c86a03fd2ef319d8d63f1e47566"
    sha256 cellar: :any_skip_relocation, catalina:       "5f2c4e444e18a561ddba667431d39bb9dc5c512fa45245d5f5e03007f5f3bf7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5bef291b004c763c8383962ad489583c9d2258895efd84a3c096b504dd3a2d0f"
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

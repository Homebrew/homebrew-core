class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-7.18.0.tgz"
  sha256 "5cbe04433e2fcb3cabe5866498056f01c60dd75a37d2ed0f579c1fa1a8e03f41"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4315d45611ecd4410d2dda95beb0148133fc4529a5282811665598ccdf1dfd09"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4315d45611ecd4410d2dda95beb0148133fc4529a5282811665598ccdf1dfd09"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4315d45611ecd4410d2dda95beb0148133fc4529a5282811665598ccdf1dfd09"
    sha256 cellar: :any_skip_relocation, ventura:        "fd4608972ff070352ff761bea5568f71c7701037630f3404f05a4f89db1fe2b5"
    sha256 cellar: :any_skip_relocation, monterey:       "fd4608972ff070352ff761bea5568f71c7701037630f3404f05a4f89db1fe2b5"
    sha256 cellar: :any_skip_relocation, big_sur:        "b2a9919dce2d8f13339df8a84ecc44fa2aed5893a236cb24ffb3a22e416b22cc"
    sha256 cellar: :any_skip_relocation, catalina:       "b2a9919dce2d8f13339df8a84ecc44fa2aed5893a236cb24ffb3a22e416b22cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4315d45611ecd4410d2dda95beb0148133fc4529a5282811665598ccdf1dfd09"
  end

  depends_on "node" => :test

  conflicts_with "corepack", because: "both installs `pnpm` and `pnpx` binaries"

  def install
    libexec.install buildpath.glob("*")
    bin.install_symlink "#{libexec}/bin/pnpm.cjs" => "pnpm"
    bin.install_symlink "#{libexec}/bin/pnpx.cjs" => "pnpx"
  end

  def caveats
    <<~EOS
      pnpm requires a Node installation to function. You can install one with:
        brew install node
    EOS
  end

  test do
    system "#{bin}/pnpm", "init"
    assert_predicate testpath/"package.json", :exist?, "package.json must exist"
  end
end

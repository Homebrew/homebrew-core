class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-7.23.0.tgz"
  sha256 "78bbf6c696a83afd4fcd2e638876e40ed1a99930cafcde107bbadbab23807bd9"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "643d2a53a56e71a34ff03f43abb9f94036a3cef49415cf81fa15adedbe3c3a30"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "643d2a53a56e71a34ff03f43abb9f94036a3cef49415cf81fa15adedbe3c3a30"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "643d2a53a56e71a34ff03f43abb9f94036a3cef49415cf81fa15adedbe3c3a30"
    sha256 cellar: :any_skip_relocation, ventura:        "7060afd530b821c0323cdf80588a3113357559630f2ef75ed52b64aea0193a67"
    sha256 cellar: :any_skip_relocation, monterey:       "7060afd530b821c0323cdf80588a3113357559630f2ef75ed52b64aea0193a67"
    sha256 cellar: :any_skip_relocation, big_sur:        "27c81ff9e5c59cd32e69519d1ad3571eff74d0a01d45aeaee59a5bea65e517f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "643d2a53a56e71a34ff03f43abb9f94036a3cef49415cf81fa15adedbe3c3a30"
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

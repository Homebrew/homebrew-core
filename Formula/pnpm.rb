class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-7.25.0.tgz"
  sha256 "5da83e8c1f9f890938325ef6bcc7fcf7ff6b2b1fb401e858f7130ba2fa6b0f6e"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0710e390799154206e1d524cfdbfe9b4cc821f4060b71f134de3404a1892a9b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0710e390799154206e1d524cfdbfe9b4cc821f4060b71f134de3404a1892a9b9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0710e390799154206e1d524cfdbfe9b4cc821f4060b71f134de3404a1892a9b9"
    sha256 cellar: :any_skip_relocation, ventura:        "2919b7d17ebef153f90f468e359ff3e858c744fcd63bbcd1546d17e2de48d902"
    sha256 cellar: :any_skip_relocation, monterey:       "2919b7d17ebef153f90f468e359ff3e858c744fcd63bbcd1546d17e2de48d902"
    sha256 cellar: :any_skip_relocation, big_sur:        "816c11b4dfd54059e10089ff3f2a9e3fb727ccd9c4c0c6da8c13eac4e17a7ad4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0710e390799154206e1d524cfdbfe9b4cc821f4060b71f134de3404a1892a9b9"
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

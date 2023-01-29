class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-7.26.2.tgz"
  sha256 "ff5eb292bf449bcf57b49474b39b24073231f763da0e8790e7457ec20c41b4af"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "710a28f4dc51cf605367afacc9c74f526a6f15e2a72e7820cfc1b53a32b53304"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "710a28f4dc51cf605367afacc9c74f526a6f15e2a72e7820cfc1b53a32b53304"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "710a28f4dc51cf605367afacc9c74f526a6f15e2a72e7820cfc1b53a32b53304"
    sha256 cellar: :any_skip_relocation, ventura:        "81a27ac8f51830ff1361023dcf48f8d789e1b685b62ff8d581ac63077e02b782"
    sha256 cellar: :any_skip_relocation, monterey:       "81a27ac8f51830ff1361023dcf48f8d789e1b685b62ff8d581ac63077e02b782"
    sha256 cellar: :any_skip_relocation, big_sur:        "29474093631c70a8d311b9ae65074572258eafe76cbc66cffac2c958045252f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "710a28f4dc51cf605367afacc9c74f526a6f15e2a72e7820cfc1b53a32b53304"
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

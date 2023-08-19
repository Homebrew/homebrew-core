class Pnpm < Formula
  require "language/node"

  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-8.6.12.tgz"
  sha256 "3ed40ffc6cbb00790ab325e9d3ff5517a3ed5b763ec53a411707b1702a411174"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "021a7ebfa227d76b0c6974645c142bb86bb3d8348ae32b5946c73680650ebbd3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "021a7ebfa227d76b0c6974645c142bb86bb3d8348ae32b5946c73680650ebbd3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "021a7ebfa227d76b0c6974645c142bb86bb3d8348ae32b5946c73680650ebbd3"
    sha256 cellar: :any_skip_relocation, ventura:        "bf300a76127f06a3bfd743d14a51452c23c5fb151f8a37900e1b342d5dfb888c"
    sha256 cellar: :any_skip_relocation, monterey:       "bf300a76127f06a3bfd743d14a51452c23c5fb151f8a37900e1b342d5dfb888c"
    sha256 cellar: :any_skip_relocation, big_sur:        "1db4f485f5a47be14f8272400becaed9396a456b4113f92c871a569a6a5c0646"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "021a7ebfa227d76b0c6974645c142bb86bb3d8348ae32b5946c73680650ebbd3"
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

class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-7.13.0.tgz"
  sha256 "d567c4a8f52c89401b2e9e8e40e7e7d5d13d991ab197c93a246fee1fd22c000d"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4701d12e3a18cee20106fde48b6149f69c58d69e970b3be1612ce14c6cd71113"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4701d12e3a18cee20106fde48b6149f69c58d69e970b3be1612ce14c6cd71113"
    sha256 cellar: :any_skip_relocation, monterey:       "db94fe3de0369e5d90678c4deabc3d75501570436debe978f36c53f095e24dce"
    sha256 cellar: :any_skip_relocation, big_sur:        "0e09a0ba2b3028991ab9ea24f5c4a88d9cdc4f31ee7ba1eadbacd65b0baf5b7a"
    sha256 cellar: :any_skip_relocation, catalina:       "0e09a0ba2b3028991ab9ea24f5c4a88d9cdc4f31ee7ba1eadbacd65b0baf5b7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4701d12e3a18cee20106fde48b6149f69c58d69e970b3be1612ce14c6cd71113"
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

class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-7.25.1.tgz"
  sha256 "2ae0888b3aae1cac089c7099f13282a1768786267c7c86886bb73215218f70a4"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3ccf60e5b24098eb2d5e51810b6c668f51881ee70ec5aa8b59eb5fbd3622abb5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ccf60e5b24098eb2d5e51810b6c668f51881ee70ec5aa8b59eb5fbd3622abb5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3ccf60e5b24098eb2d5e51810b6c668f51881ee70ec5aa8b59eb5fbd3622abb5"
    sha256 cellar: :any_skip_relocation, ventura:        "fe0bc1c5e354fa3b048e9b515bc37c36a130d120dc8c94ad7a2d3a9bc6851556"
    sha256 cellar: :any_skip_relocation, monterey:       "fe0bc1c5e354fa3b048e9b515bc37c36a130d120dc8c94ad7a2d3a9bc6851556"
    sha256 cellar: :any_skip_relocation, big_sur:        "8adc2c3aa667aae9b01a3fa49e6d07c4bb4b79aea0c96d043eaa8a12bb88b73d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ccf60e5b24098eb2d5e51810b6c668f51881ee70ec5aa8b59eb5fbd3622abb5"
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

class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-7.28.0.tgz"
  sha256 "17755d74ed6803a6e7a5bfdbc314fdd74ae7f8e66bc06c9d85fc01ebf08b6b51"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e46527553aa2c16d76a71eb22d9dd417346d1721b56559049d1cd3c0bc52983"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e46527553aa2c16d76a71eb22d9dd417346d1721b56559049d1cd3c0bc52983"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2e46527553aa2c16d76a71eb22d9dd417346d1721b56559049d1cd3c0bc52983"
    sha256 cellar: :any_skip_relocation, ventura:        "e6f94225d479efdf48b09fc17b4a83d4578fb4db241e5a2786bc2140fc1be175"
    sha256 cellar: :any_skip_relocation, monterey:       "e6f94225d479efdf48b09fc17b4a83d4578fb4db241e5a2786bc2140fc1be175"
    sha256 cellar: :any_skip_relocation, big_sur:        "a13b66366dda238078cf079558fd7510775cfca64285137df2384eaa3d4b143e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e46527553aa2c16d76a71eb22d9dd417346d1721b56559049d1cd3c0bc52983"
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

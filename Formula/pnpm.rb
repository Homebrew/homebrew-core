class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-7.14.1.tgz"
  sha256 "a577ae0336a23c21519db73440170f5a83affb19cc36fea4af2c2aeefcd9d23c"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6035967c7bc15b2dce4e152c2359a4c0c178e25788e3720c636193a7b06dfd86"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6035967c7bc15b2dce4e152c2359a4c0c178e25788e3720c636193a7b06dfd86"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6035967c7bc15b2dce4e152c2359a4c0c178e25788e3720c636193a7b06dfd86"
    sha256 cellar: :any_skip_relocation, monterey:       "821db868503047f82504e9165f11cc9f08a75a0a20bfae7e6ec10850a121021e"
    sha256 cellar: :any_skip_relocation, big_sur:        "7a3bafdb494ed09ad8f9f60a725561d3d951ac3581b2f4ff22db50c1bba34c33"
    sha256 cellar: :any_skip_relocation, catalina:       "7a3bafdb494ed09ad8f9f60a725561d3d951ac3581b2f4ff22db50c1bba34c33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6035967c7bc15b2dce4e152c2359a4c0c178e25788e3720c636193a7b06dfd86"
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

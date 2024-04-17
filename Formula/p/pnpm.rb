class Pnpm < Formula
  require "language/node"

  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-9.0.1.tgz"
  sha256 "46d50ee2afecb42b185ebbd662dc7bdd52ef5be56bf035bb615cab81a75345df"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ff6ac6ecaac4ef21da82cb01ec51e5ebf77492ee57f3ce965e38e5c8732841a3"
    sha256 cellar: :any,                 arm64_ventura:  "ff6ac6ecaac4ef21da82cb01ec51e5ebf77492ee57f3ce965e38e5c8732841a3"
    sha256 cellar: :any,                 arm64_monterey: "ff6ac6ecaac4ef21da82cb01ec51e5ebf77492ee57f3ce965e38e5c8732841a3"
    sha256 cellar: :any,                 sonoma:         "137119528c4efeadc99e72c04cdc811b066d75dd81bcad7b1d5bf7bcfe5a34a9"
    sha256 cellar: :any,                 ventura:        "137119528c4efeadc99e72c04cdc811b066d75dd81bcad7b1d5bf7bcfe5a34a9"
    sha256 cellar: :any,                 monterey:       "137119528c4efeadc99e72c04cdc811b066d75dd81bcad7b1d5bf7bcfe5a34a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "404da3723cade9f26e9236821eaeea947f5aa9ce04a6095b694b10cd22b04e4b"
  end

  depends_on "node" => :test

  conflicts_with "corepack", because: "both installs `pnpm` and `pnpx` binaries"

  def install
    libexec.install buildpath.glob("*")
    bin.install_symlink "#{libexec}/bin/pnpm.cjs" => "pnpm"
    bin.install_symlink "#{libexec}/bin/pnpx.cjs" => "pnpx"

    # remove non-native architecture pre-built binaries
    (libexec/"dist").glob("reflink.*.node").each do |f|
      next if f.arch == Hardware::CPU.arch

      rm f
    end
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

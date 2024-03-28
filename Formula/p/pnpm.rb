class Pnpm < Formula
  require "language/node"

  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-8.15.5.tgz"
  sha256 "4b4efa12490e5055d59b9b9fc9438b7d581a6b7af3b5675eb5c5f447cee1a589"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a698d0a246cd0eee72cad83f6fa86d609bffbadd418a8e5a17194a5d30c04ee3"
    sha256 cellar: :any,                 arm64_ventura:  "a698d0a246cd0eee72cad83f6fa86d609bffbadd418a8e5a17194a5d30c04ee3"
    sha256 cellar: :any,                 arm64_monterey: "a698d0a246cd0eee72cad83f6fa86d609bffbadd418a8e5a17194a5d30c04ee3"
    sha256 cellar: :any,                 sonoma:         "92eec8898449ec3c422f05774b5feffff045add2d2d3b745d52ca77294a90d6e"
    sha256 cellar: :any,                 ventura:        "92eec8898449ec3c422f05774b5feffff045add2d2d3b745d52ca77294a90d6e"
    sha256 cellar: :any,                 monterey:       "92eec8898449ec3c422f05774b5feffff045add2d2d3b745d52ca77294a90d6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de6b837b0741f6651d0b4407af6064a782267e1c3a1cd7c8a81b0bd73813e555"
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

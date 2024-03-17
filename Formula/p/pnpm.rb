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
    sha256 cellar: :any,                 arm64_sonoma:   "11b566a67f996493d19ef01feda9bfc8b2938268f17b0920aa9dd9771d7de7b1"
    sha256 cellar: :any,                 arm64_ventura:  "11b566a67f996493d19ef01feda9bfc8b2938268f17b0920aa9dd9771d7de7b1"
    sha256 cellar: :any,                 arm64_monterey: "11b566a67f996493d19ef01feda9bfc8b2938268f17b0920aa9dd9771d7de7b1"
    sha256 cellar: :any,                 sonoma:         "4a424a0a97b93c8e7d90aa9d7412bc8b2224f9a1c6c87f30e002c67351043c80"
    sha256 cellar: :any,                 ventura:        "4a424a0a97b93c8e7d90aa9d7412bc8b2224f9a1c6c87f30e002c67351043c80"
    sha256 cellar: :any,                 monterey:       "4a424a0a97b93c8e7d90aa9d7412bc8b2224f9a1c6c87f30e002c67351043c80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2864da6a4fb933ea8765c23fe16fa8c852c4678b4cf08231566a985cd9ff0e71"
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

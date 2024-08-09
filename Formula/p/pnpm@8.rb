class PnpmAT8 < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-8.15.9.tgz"
  sha256 "daa27a0b541bc635323ff96c2ded995467ff9fe6d69ff67021558aa9ad9dcc36"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-8"
    regex(/["']version["']:\s*?["'](8[^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1817fa1a56d40c80b7dc0537277deaccc5f59b60592d58378ecede03a9978a29"
    sha256 cellar: :any,                 arm64_ventura:  "1817fa1a56d40c80b7dc0537277deaccc5f59b60592d58378ecede03a9978a29"
    sha256 cellar: :any,                 arm64_monterey: "1817fa1a56d40c80b7dc0537277deaccc5f59b60592d58378ecede03a9978a29"
    sha256 cellar: :any,                 sonoma:         "9ed339801ba354d0a29eae81280393417485d47a41cb2ae37822ad3222b0d7c9"
    sha256 cellar: :any,                 ventura:        "9ed339801ba354d0a29eae81280393417485d47a41cb2ae37822ad3222b0d7c9"
    sha256 cellar: :any,                 monterey:       "9ed339801ba354d0a29eae81280393417485d47a41cb2ae37822ad3222b0d7c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16489457ee27235fa2c6be678875d549e56c7cc5c9ba20588d2a02471c00eebe"
  end

  keg_only :versioned_formula

  disable! date: "2025-04-30", because: :unmaintained

  depends_on "node" => [:build, :test]

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
    bin.install_symlink bin/"pnpm" => "pnpm@8"
    bin.install_symlink bin/"pnpx" => "pnpx@8"

    generate_completions_from_executable(bin/"pnpm", "completion")

    # remove non-native architecture pre-built binaries
    (libexec/"lib/node_modules/pnpm/dist").glob("reflink.*.node").each do |f|
      next if f.arch == Hardware::CPU.arch

      rm f
    end
  end

  def caveats
    <<~EOS
      pnpm@8 requires a Node installation to function. You can install one with:
        brew install node
    EOS
  end

  test do
    system bin/"pnpm", "init"
    assert_predicate testpath/"package.json", :exist?, "package.json must exist"
  end
end

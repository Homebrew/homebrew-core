class Pnpm < Formula
  require "language/node"

  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-8.13.1.tgz"
  sha256 "9e5f62ce5f2b7d4ceb3c2848f41cf0b33032c24d683c7088b53f62b1885fb246"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "dc08f22967ad8984b49a546769ffe62ecb0914c5d3cd59820002b1a6bb181c58"
    sha256 cellar: :any,                 arm64_ventura:  "dc08f22967ad8984b49a546769ffe62ecb0914c5d3cd59820002b1a6bb181c58"
    sha256 cellar: :any,                 arm64_monterey: "dc08f22967ad8984b49a546769ffe62ecb0914c5d3cd59820002b1a6bb181c58"
    sha256 cellar: :any,                 sonoma:         "45447b3e738d71170ed425d8cb23ace650078d022b755c6084ee5ad5cb55a52b"
    sha256 cellar: :any,                 ventura:        "45447b3e738d71170ed425d8cb23ace650078d022b755c6084ee5ad5cb55a52b"
    sha256 cellar: :any,                 monterey:       "45447b3e738d71170ed425d8cb23ace650078d022b755c6084ee5ad5cb55a52b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ed0d0dc48d452870405827174c1407e03691ca962e5afb6339cac6f83bef803"
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

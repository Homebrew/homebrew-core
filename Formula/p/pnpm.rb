class Pnpm < Formula
  require "language/node"

  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-8.7.3.tgz"
  sha256 "672482301c0ca3f0ac1ae58c0a564ea3720b39a15e13826aeed4b7a8867a309b"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0f2fda78a1d548d8eb26b78eebe66c8823bfa32d242afdd51941dad37c24961a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f2fda78a1d548d8eb26b78eebe66c8823bfa32d242afdd51941dad37c24961a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0f2fda78a1d548d8eb26b78eebe66c8823bfa32d242afdd51941dad37c24961a"
    sha256 cellar: :any_skip_relocation, ventura:        "fbb9267538edb54bdbb2ced47bdc245752a25c83208dd02a82a70620c5c3dc50"
    sha256 cellar: :any_skip_relocation, monterey:       "fbb9267538edb54bdbb2ced47bdc245752a25c83208dd02a82a70620c5c3dc50"
    sha256 cellar: :any_skip_relocation, big_sur:        "def0cb3bf3d45ea8984dbbba2e3513bc27157760e623bf10032e91a488a51460"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f2fda78a1d548d8eb26b78eebe66c8823bfa32d242afdd51941dad37c24961a"
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

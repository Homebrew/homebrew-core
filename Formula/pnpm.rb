class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-8.3.1.tgz"
  sha256 "ce038ba2617f7a93d0b1f24b733b9d64258b15c97a14c6f37673c8d49e033d9a"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "78ecd13f60c3baf6913933c8494ca17fc4e5b9f93c46bbc131312ffe41fe7f88"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "78ecd13f60c3baf6913933c8494ca17fc4e5b9f93c46bbc131312ffe41fe7f88"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "78ecd13f60c3baf6913933c8494ca17fc4e5b9f93c46bbc131312ffe41fe7f88"
    sha256 cellar: :any_skip_relocation, ventura:        "2f4f18876a3e2823f86f5500b7c47c173695e7f21eba007c2b7689dd12301145"
    sha256 cellar: :any_skip_relocation, monterey:       "2f4f18876a3e2823f86f5500b7c47c173695e7f21eba007c2b7689dd12301145"
    sha256 cellar: :any_skip_relocation, big_sur:        "4be656f6ff04e145810fb6e19f08fb01030798cec610c9d618b1fb01121d9f64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78ecd13f60c3baf6913933c8494ca17fc4e5b9f93c46bbc131312ffe41fe7f88"
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

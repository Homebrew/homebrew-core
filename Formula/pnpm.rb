class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-7.21.0.tgz"
  sha256 "55c2246a81d433295fb0c701a349b3254de95348976f02e5acef031fc1045111"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "58b61b0ff8836122497cff47fd0b6bb8e488c749a15fb278fbdad20cdee9a1cd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "58b61b0ff8836122497cff47fd0b6bb8e488c749a15fb278fbdad20cdee9a1cd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "58b61b0ff8836122497cff47fd0b6bb8e488c749a15fb278fbdad20cdee9a1cd"
    sha256 cellar: :any_skip_relocation, ventura:        "f3898afc2660dd3e9fde94792da30fa6a14dfa7d8d0eee6fcd31e58dd5c42497"
    sha256 cellar: :any_skip_relocation, monterey:       "f3898afc2660dd3e9fde94792da30fa6a14dfa7d8d0eee6fcd31e58dd5c42497"
    sha256 cellar: :any_skip_relocation, big_sur:        "8a00ed487848e8e25bef38058752cded66277eb39ce2ab8dd1df2efed0eefcfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58b61b0ff8836122497cff47fd0b6bb8e488c749a15fb278fbdad20cdee9a1cd"
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

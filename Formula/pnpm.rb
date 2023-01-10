class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-7.24.2.tgz"
  sha256 "43191456dc8378010240db22a3726a1f13fc8ad9c533cf042210dbaf07584b26"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6094d519fd86ff51141984d7bd0b15aa3e54c747e9d1ed6a35e18e6165f93ba7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6094d519fd86ff51141984d7bd0b15aa3e54c747e9d1ed6a35e18e6165f93ba7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6094d519fd86ff51141984d7bd0b15aa3e54c747e9d1ed6a35e18e6165f93ba7"
    sha256 cellar: :any_skip_relocation, ventura:        "d551de744e686816c3f64985c2eb4c13ffbb9c4f181d4b8bc6a6d445535d9a17"
    sha256 cellar: :any_skip_relocation, monterey:       "d551de744e686816c3f64985c2eb4c13ffbb9c4f181d4b8bc6a6d445535d9a17"
    sha256 cellar: :any_skip_relocation, big_sur:        "0d39ae0b75ebc9f3868e1a6ef6cfffa2f838a5c08146ec27116966f7b8e2d9df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6094d519fd86ff51141984d7bd0b15aa3e54c747e9d1ed6a35e18e6165f93ba7"
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

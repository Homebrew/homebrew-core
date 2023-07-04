class Pnpm < Formula
  require "language/node"

  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-8.6.6.tgz"
  sha256 "52f3e7d33884929f1902a7494a616d844b506ed46592e65463ba45e97cc25a1b"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a77b48ab8a56eaf33f44dfb45f3099e0a10d8d68254c8b289d72997db5014dd4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a77b48ab8a56eaf33f44dfb45f3099e0a10d8d68254c8b289d72997db5014dd4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a77b48ab8a56eaf33f44dfb45f3099e0a10d8d68254c8b289d72997db5014dd4"
    sha256 cellar: :any_skip_relocation, ventura:        "0d31f89ece086aafcf6191dbacb5b6aab51fc8b209d7681eb2e1d010255189d5"
    sha256 cellar: :any_skip_relocation, monterey:       "0d31f89ece086aafcf6191dbacb5b6aab51fc8b209d7681eb2e1d010255189d5"
    sha256 cellar: :any_skip_relocation, big_sur:        "f1f24b3ab3f12a370cc57336cdf14d85fcdc40fb3caebebbd0780e93718a5702"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a77b48ab8a56eaf33f44dfb45f3099e0a10d8d68254c8b289d72997db5014dd4"
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

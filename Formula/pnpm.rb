class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-8.6.1.tgz"
  sha256 "5380612e01e0a3029991d3f329f07429313f4825de47b885b4bb3d1aec9e44e1"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ee3773969139e707bbe424aa3740fce2cbaafadc1af6c54e51474d5f1a880520"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee3773969139e707bbe424aa3740fce2cbaafadc1af6c54e51474d5f1a880520"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ee3773969139e707bbe424aa3740fce2cbaafadc1af6c54e51474d5f1a880520"
    sha256 cellar: :any_skip_relocation, ventura:        "b9a01672a4f8f0454d8e5bf5e1d57a0c3a9d17ea5fdf78966432183b3de5c656"
    sha256 cellar: :any_skip_relocation, monterey:       "b9a01672a4f8f0454d8e5bf5e1d57a0c3a9d17ea5fdf78966432183b3de5c656"
    sha256 cellar: :any_skip_relocation, big_sur:        "87dd8c929950ce05f6c3220e821e9a46641ef2c6da1fe157bf92cea6dd3390df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee3773969139e707bbe424aa3740fce2cbaafadc1af6c54e51474d5f1a880520"
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

class Pnpm < Formula
  require "language/node"

  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-8.6.5.tgz"
  sha256 "91dd45b4762c73f58f354999867854fcbe7376235474d131080fe391f2eb5227"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3c23badcd974a0c8421aff6c55dc99918ca24974b2c09d3ef03fdabbf148d3a2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c23badcd974a0c8421aff6c55dc99918ca24974b2c09d3ef03fdabbf148d3a2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3c23badcd974a0c8421aff6c55dc99918ca24974b2c09d3ef03fdabbf148d3a2"
    sha256 cellar: :any_skip_relocation, ventura:        "3349d7809888035614b2421316d8edbf5efa466ec695eb49a3f7d10ddcfb6a32"
    sha256 cellar: :any_skip_relocation, monterey:       "3349d7809888035614b2421316d8edbf5efa466ec695eb49a3f7d10ddcfb6a32"
    sha256 cellar: :any_skip_relocation, big_sur:        "9b104e18d45c8265fac68cc52873acfa1cf530c88a4cacfe7b7f89a8a7679b4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c23badcd974a0c8421aff6c55dc99918ca24974b2c09d3ef03fdabbf148d3a2"
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

class Pnpm < Formula
  require "language/node"

  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-8.15.3.tgz"
  sha256 "fc4a49bd609550a41e14d20efbce802a4b892aa4cac877322de2f0924f122991"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8e5806b938edbb814f7d235b28a133f94882790111543f8b7df142ad66f2bfdd"
    sha256 cellar: :any,                 arm64_ventura:  "8e5806b938edbb814f7d235b28a133f94882790111543f8b7df142ad66f2bfdd"
    sha256 cellar: :any,                 arm64_monterey: "8e5806b938edbb814f7d235b28a133f94882790111543f8b7df142ad66f2bfdd"
    sha256 cellar: :any,                 sonoma:         "ddc7fd3bb8aec5e20b5c8ae6ebca1315c2826620a9bda22390983c71bb4d9fb6"
    sha256 cellar: :any,                 ventura:        "ddc7fd3bb8aec5e20b5c8ae6ebca1315c2826620a9bda22390983c71bb4d9fb6"
    sha256 cellar: :any,                 monterey:       "ddc7fd3bb8aec5e20b5c8ae6ebca1315c2826620a9bda22390983c71bb4d9fb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "441ad1a6614f0366bbe50a60cf57981e66c29de00a22d6ca4a4b499b27cb28d7"
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

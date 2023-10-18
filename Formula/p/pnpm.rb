class Pnpm < Formula
  require "language/node"

  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-8.9.2.tgz"
  sha256 "8d62573d93061f2722b7b48c9739e96cd4603c3ab153bc81c619dcb9861a214e"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8ace00300c5ef7dfcbde7de652a19cbac183aad05d7d50e6c3914fe59818ac2f"
    sha256 cellar: :any,                 arm64_ventura:  "8ace00300c5ef7dfcbde7de652a19cbac183aad05d7d50e6c3914fe59818ac2f"
    sha256 cellar: :any,                 arm64_monterey: "8ace00300c5ef7dfcbde7de652a19cbac183aad05d7d50e6c3914fe59818ac2f"
    sha256 cellar: :any,                 sonoma:         "d64744925d02429ef815f8e9298805885655209bee5e696a0da770eb8e1f3c8b"
    sha256 cellar: :any,                 ventura:        "d64744925d02429ef815f8e9298805885655209bee5e696a0da770eb8e1f3c8b"
    sha256 cellar: :any,                 monterey:       "d64744925d02429ef815f8e9298805885655209bee5e696a0da770eb8e1f3c8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f33a9304901b5bddaa3378ebb59001c9bfa9e474d1138d0b99eb1a225ab9481"
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

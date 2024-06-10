class Pnpm < Formula
  require "language/node"

  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-9.3.0.tgz"
  sha256 "e1f9e8d1a16607a46dd3c158b5f7a7dc7945501d1c6222d454d63d033d1d918f"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9e838f00d77544378a338fa15705fae3cd9bbd0e98e6867b3513c66ffeef2590"
    sha256 cellar: :any,                 arm64_ventura:  "9e838f00d77544378a338fa15705fae3cd9bbd0e98e6867b3513c66ffeef2590"
    sha256 cellar: :any,                 arm64_monterey: "9e838f00d77544378a338fa15705fae3cd9bbd0e98e6867b3513c66ffeef2590"
    sha256 cellar: :any,                 sonoma:         "7ce12a79b8762e95dd0dc1a1f5c352a171f0fbdf5822c9297fa1cdfd23f8980a"
    sha256 cellar: :any,                 ventura:        "7ce12a79b8762e95dd0dc1a1f5c352a171f0fbdf5822c9297fa1cdfd23f8980a"
    sha256 cellar: :any,                 monterey:       "7ce12a79b8762e95dd0dc1a1f5c352a171f0fbdf5822c9297fa1cdfd23f8980a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "800473a282863236ba8d8c0aa1cf80df61441f3619ed7d36c32296753c0c424b"
  end

  depends_on "node" => [:build, :test]

  conflicts_with "corepack", because: "both installs `pnpm` and `pnpx` binaries"

  def install
    libexec.install buildpath.glob("*")
    bin.install_symlink "#{libexec}/bin/pnpm.cjs" => "pnpm"
    bin.install_symlink "#{libexec}/bin/pnpx.cjs" => "pnpx"

    generate_completions_from_executable(bin/"pnpm", "completion")

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

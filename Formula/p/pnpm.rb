class Pnpm < Formula
  require "language/node"

  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-9.0.6.tgz"
  sha256 "0624e30eff866cdeb363b15061bdb7fd9425b17bc1bb42c22f5f4efdea21f6b3"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a0fc1a6363fe6f9abcbe35dbd6cd17a6ad055e0e1099441a6c33c8bde024c004"
    sha256 cellar: :any,                 arm64_ventura:  "a0fc1a6363fe6f9abcbe35dbd6cd17a6ad055e0e1099441a6c33c8bde024c004"
    sha256 cellar: :any,                 arm64_monterey: "a0fc1a6363fe6f9abcbe35dbd6cd17a6ad055e0e1099441a6c33c8bde024c004"
    sha256 cellar: :any,                 sonoma:         "195f27040ce2381d7110d23835ef759f91c6c581077ea65e6c2e8d848496ef51"
    sha256 cellar: :any,                 ventura:        "195f27040ce2381d7110d23835ef759f91c6c581077ea65e6c2e8d848496ef51"
    sha256 cellar: :any,                 monterey:       "195f27040ce2381d7110d23835ef759f91c6c581077ea65e6c2e8d848496ef51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4306c0729e74d11685b946c3c33a0707708e61d398ed8ea671afd7d7965906c9"
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

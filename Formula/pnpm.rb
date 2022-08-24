class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-7.9.5.tgz"
  sha256 "f9e44c2f411fc763ce6dec9bd67aa14064da8a991b0c6d2a799246a13cbac278"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "509699cd9c85a5ff53c90b95b99684549ccba2701ec46486856ad4e66204853c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "509699cd9c85a5ff53c90b95b99684549ccba2701ec46486856ad4e66204853c"
    sha256 cellar: :any_skip_relocation, monterey:       "6fa82740c764ee8ecc488b3315143f3fbd90c273aaef4cac0ad372f29791911d"
    sha256 cellar: :any_skip_relocation, big_sur:        "8a0c607dfb2fa761ac669bd89ff63f0fd9dbc739c9a0e96008522b881859705b"
    sha256 cellar: :any_skip_relocation, catalina:       "8a0c607dfb2fa761ac669bd89ff63f0fd9dbc739c9a0e96008522b881859705b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "509699cd9c85a5ff53c90b95b99684549ccba2701ec46486856ad4e66204853c"
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

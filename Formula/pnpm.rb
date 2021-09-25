class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-6.15.1.tgz"
  sha256 "f8e8bc663863b42ad5daed23f321efa6d178939e2468cedebec5306ae6efaa3d"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e0d669c48801ee9a3f0a49d99f81f2a50dcd1e879526b77a1367c1ae6daa9811"
    sha256 cellar: :any_skip_relocation, big_sur:       "cf54f4d92677826a6d9eaf8653cffb849708dde2ac0291336e3d37fbd0de847d"
    sha256 cellar: :any_skip_relocation, catalina:      "cf54f4d92677826a6d9eaf8653cffb849708dde2ac0291336e3d37fbd0de847d"
    sha256 cellar: :any_skip_relocation, mojave:        "cf54f4d92677826a6d9eaf8653cffb849708dde2ac0291336e3d37fbd0de847d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0d669c48801ee9a3f0a49d99f81f2a50dcd1e879526b77a1367c1ae6daa9811"
  end

  depends_on "node"

  def install
    npmrc = if OS.mac? ? "global-bin-dir = ${HOME}/Library/pnpm\n" : "global-bin-dir = ${HOME}/.local/pnpm\n"
    (prefix/"etc/npmrc").write npmrc
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  def caveats
    pnpm_path = nil
    on_macos do
      pnpm_path = "$HOME/Library/pnpm"
    end
    on_linux do
      pnpm_path = "$HOME/.local/pnpm"
    end
    <<~EOS if pnpm_path
      Add the following to #{shell_profile} or your desired shell
      configuration file if you would like global packages in PATH:
        export PATH="#{pnpm_path}:$PATH"
    EOS
  end

  test do
    pnpm_path = nil
    pnpm_path = OS.mac? ? testpath/"Library/pnpm" : testpath/".local/pnpm"
    pnpm_path.mkpath
    ENV.prepend_path "PATH", pnpm_path
    system "#{bin}/pnpm", "env", "use", "--global", "16"
    system "#{bin}/pnpm", "init", "-y"
    assert_predicate testpath/"package.json", :exist?, "package.json must exist"
    system "#{bin}/pnpm", "add", "--global", "typescript"
    assert_predicate pnpm_path/"tsc", :exist?, "tsc must exist in global bin"
  end
end

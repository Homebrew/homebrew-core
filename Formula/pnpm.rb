class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-5.2.0.tgz"
  sha256 "1cab18adc1286ff8261fa492afee4dd6306555df8af697df09512fdeb020adba"

  bottle do
    cellar :any_skip_relocation
    sha256 "eb440adb24d4a953e290e40c1b4fa298cd4baec59efa440df348d231e5865889" => :catalina
    sha256 "21778bd9b004a0f9a0b9157444619d850a7b0b00d30a3be08174eab704a43e4a" => :mojave
    sha256 "31f0f14ae59c83b0eacdbb46d34e319d744e596c00263e1a00623335c0f58c20" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/pnpm", "init", "-y"
    assert_predicate testpath/"package.json", :exist?, "package.json must exist"
  end
end

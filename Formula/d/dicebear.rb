require "language/node"

class Dicebear < Formula
  desc "CLI for DiceBear - An avatar library for designers and developers"
  homepage "https://github.com/dicebear/dicebear"
  url "https://registry.npmjs.org/dicebear/-/dicebear-7.1.0.tgz"
  sha256 "27a3be6cb2013393981941ef346d08d33dba6165141fcd09769e10be95305308"
  license "MIT"

  bottle do
    sha256                               arm64_sonoma:   "74731a441aef1acc7217e7a107e74314ecabc579c389666ba3425fe87c93208b"
    sha256                               arm64_ventura:  "906bea7717c459dab153c5ac0b05d7af3f6d2b3314e6fee1dc0bc77cd2ade5f3"
    sha256                               arm64_monterey: "9a4ea38bf2d2721c7ee7d1deeffa97e14c1049543d10631fbacb016f8c487557"
    sha256                               sonoma:         "f3edb08ba49c720dc105fba178f4669bae5bf454de72ef9128a78b10aff280cd"
    sha256                               ventura:        "a1c7c6be3717efcf4a041d03b8d7e17bdb9c3e928e3bfc47bd75f64ee1ff41ad"
    sha256                               monterey:       "d38bdd1be397bd3807c88f62dc936004bea25ce105307515abc0565f21b91e8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11a432fdc89eb88b973776a31dad445ff1405cace1dee6d0df4fbeba97f47b23"
  end

  depends_on "node"

  on_linux do
    depends_on "vips"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Delete native binaries installed by npm, as we dont support `musl` for a `libc` implementation
    node_modules = libexec/"lib/node_modules/dicebear/node_modules"
    (node_modules/"@resvg/resvg-js-linux-x64-musl/resvgjs.linux-x64-musl.node").unlink if OS.linux?

    # Remove incompatible pre-built `bare-fs`/`bare-os` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os}/prebuilds/*")
                .each { |dir| dir.rmtree if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    output = shell_output("#{bin}/dicebear avataaars")
    assert_match "Avataaars by Pablo Stanley", output
    assert_predicate testpath/"avataaars-0.svg", :exist?

    assert_match version.to_s, shell_output("#{bin}/dicebear --version")
  end
end

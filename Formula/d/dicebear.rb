require "language/node"

class Dicebear < Formula
  desc "CLI for DiceBear - An avatar library for designers and developers"
  homepage "https://github.com/dicebear/dicebear"
  url "https://registry.npmjs.org/dicebear/-/dicebear-9.0.1.tgz"
  sha256 "497e578ba8f0865d640d5fe3fd6c4e3b9b0426cd1daf09683d827a26474be932"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6beeafcc8e0f779fba4d814bdc9d27d5d9dfb9be03b2ec3a477c8a73d82250e5"
    sha256 cellar: :any,                 arm64_ventura:  "6beeafcc8e0f779fba4d814bdc9d27d5d9dfb9be03b2ec3a477c8a73d82250e5"
    sha256 cellar: :any,                 arm64_monterey: "6beeafcc8e0f779fba4d814bdc9d27d5d9dfb9be03b2ec3a477c8a73d82250e5"
    sha256 cellar: :any,                 sonoma:         "5e5d422081264ecc935e786ca70f7e299cb5d566a09178660e5b790a5f29b730"
    sha256 cellar: :any,                 ventura:        "5e5d422081264ecc935e786ca70f7e299cb5d566a09178660e5b790a5f29b730"
    sha256 cellar: :any,                 monterey:       "5e5d422081264ecc935e786ca70f7e299cb5d566a09178660e5b790a5f29b730"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1164b9bb831d274fb337e079974cf6e5db59c66bc07af576087257008ce21416"
  end

  depends_on "node"

  on_linux do
    depends_on "vips"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    node_modules = libexec/"lib/node_modules/dicebear/node_modules"

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

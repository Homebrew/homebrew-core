class Dicebear < Formula
  desc "CLI for DiceBear - An avatar library for designers and developers"
  homepage "https://github.com/dicebear/dicebear"
  url "https://registry.npmjs.org/dicebear/-/dicebear-9.2.4.tgz"
  sha256 "ab8e430f1b4fb999372cf78b274e04ca999fff16891f19ece63f63ab7f7aa373"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "22e8bc01e12dddc25982aecfe7436c0c0ac53299191039060b2d1b2f440ac6a0"
    sha256 cellar: :any,                 arm64_sequoia: "6cd2e65e517ada31b350201063bab3ec51163447732ba73541e68158d565b1ae"
    sha256 cellar: :any,                 arm64_sonoma:  "6cd2e65e517ada31b350201063bab3ec51163447732ba73541e68158d565b1ae"
    sha256 cellar: :any,                 arm64_ventura: "6cd2e65e517ada31b350201063bab3ec51163447732ba73541e68158d565b1ae"
    sha256 cellar: :any,                 sonoma:        "bec6992b45e1ace0b2862d90c2764aaf21d270227e652d05620078e3ec8e4f9a"
    sha256 cellar: :any,                 ventura:       "bec6992b45e1ace0b2862d90c2764aaf21d270227e652d05620078e3ec8e4f9a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7828cf098c33bd975cad5f657ec7cdf4faad2c78cacf65293f0713fc42e198ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45af81803b2bf97e8d4f50f64ba27a817f88b9b5cad916fa22bbf9232a78dc38"
  end

  depends_on "node"

  on_linux do
    depends_on "vips"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    node_modules = libexec/"lib/node_modules/dicebear/node_modules"

    # Remove incompatible pre-built `bare-fs`/`bare-os` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    output = shell_output("#{bin}/dicebear avataaars")
    assert_match "Avataaars by Pablo Stanley", output
    assert_path_exists testpath/"avataaars-0.svg"

    assert_match version.to_s, shell_output("#{bin}/dicebear --version")
  end
end

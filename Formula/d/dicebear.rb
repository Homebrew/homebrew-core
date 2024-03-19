require "language/node"

class Dicebear < Formula
  desc "CLI for DiceBear - An avatar library for designers and developers"
  homepage "https://github.com/dicebear/dicebear"
  url "https://registry.npmjs.org/dicebear/-/dicebear-8.0.0.tgz"
  sha256 "bdd8c468bdb7d14974e6f888b462eb12c7ea07d3f03ae22b40f709eb60c82c5d"
  license "MIT"

  bottle do
    sha256                               arm64_sonoma:   "6e79fa663d43d331ebf6febb6bfccee38eb784b1b414c58bc826e41977829c89"
    sha256                               arm64_ventura:  "e30db9845a7d38e59949709e9f0ba17d0c6ad575a0fdb36712b12bc5c3b0418a"
    sha256                               arm64_monterey: "d9006eeff06b9e5784b8bc0b29dc0f6b1a541eb8fe65e75af4084ceacb78d6c2"
    sha256                               sonoma:         "77fd18654a21c16fd20d014f98f84ae2803022329c68a88173693632f501b23f"
    sha256                               ventura:        "524d962bc2bcb369513f27b5ddd94a1462a5926fb03c1928a20a16a881ab5092"
    sha256                               monterey:       "0a872d482c070c321f951c05837dea2acf58b0aca60a47c4713c520336b75286"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a6494f17d622da49859e463a7dcfea6a8564d95c06b6a73466b4e79125e904f"
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

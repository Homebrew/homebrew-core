class Dicebear < Formula
  desc "CLI for DiceBear - An avatar library for designers and developers"
  homepage "https://github.com/dicebear/dicebear"
  url "https://registry.npmjs.org/dicebear/-/dicebear-9.2.3.tgz"
  sha256 "23c6ed504ee7e4d6cdd5014df7ea857ce326ff0d4de8fcabdc8e6d1cde3aecf5"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cbb6b9a9a9d965f2eae51d3e7b30df230073f01397831ce6e3083dec6746b90e"
    sha256 cellar: :any,                 arm64_sonoma:  "cbb6b9a9a9d965f2eae51d3e7b30df230073f01397831ce6e3083dec6746b90e"
    sha256 cellar: :any,                 arm64_ventura: "cbb6b9a9a9d965f2eae51d3e7b30df230073f01397831ce6e3083dec6746b90e"
    sha256                               sonoma:        "b45e93566dd19218e0253e0005f7f767077864ab46b8f909e62bc903d49d061d"
    sha256                               ventura:       "b45e93566dd19218e0253e0005f7f767077864ab46b8f909e62bc903d49d061d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8703b3672a9cc7fa19567512b71e979c58e26c250910824c648588898229b57b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9fd8ef21b0a23751090def3f59fb06f354016ca2ad41bebb3307fbf4133bc58e"
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

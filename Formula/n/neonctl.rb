class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-2.18.1.tgz"
  sha256 "9f1b5013a5a16350a590202a5a2ccf6ea59dddc8b1090bdc6e4cdcf81362b9fe"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "76649c3caee0f2b1c941d53d45239006f2f3f6dfc30c197ea0f38e0e2d3e1703"
    sha256 cellar: :any,                 arm64_sequoia: "a16713735f8adbce6c29b3d10ffc3df43be05d662a11fe8f4b67b1495b5c300c"
    sha256 cellar: :any,                 arm64_sonoma:  "a16713735f8adbce6c29b3d10ffc3df43be05d662a11fe8f4b67b1495b5c300c"
    sha256 cellar: :any,                 sonoma:        "09f80cc6b2f5ab047c536cd203fa7a4ce1dcfbbba6bd019c198cc08454b17c34"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a37551c61c0adc19df6c46b7643e0aa9428a9a7930a4413dea6740785eb8a12f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3887aab1e3e92996cd1b813930314dfa76d9a6c911b89a7d9da1a0a96f2b065c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    %w[neonctl neon].each do |cmd|
      generate_completions_from_executable(bin/cmd, "completion", shells: [:bash, :zsh])
    end

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/neonctl/node_modules"
    node_modules.glob("{bare-fs,bare-os,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    output = shell_output("#{bin}/neonctl --api-key DOES-NOT-EXIST projects create 2>&1", 1)
    assert_match("Authentication failed", output)
  end
end

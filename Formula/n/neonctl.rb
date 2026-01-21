class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-2.20.1.tgz"
  sha256 "f902140862ed6f601f4148fc9a7e63db70c091af1f9c96154a9c3f6acd35b242"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3c0f09b4504d467d15129b49c1964b286366f29ff5c94bb3b1039763455226a6"
    sha256 cellar: :any,                 arm64_sequoia: "3e2bb92dbc0d9fa495062e04c45cadd0f6d1558ca4573014646b2545a7e75531"
    sha256 cellar: :any,                 arm64_sonoma:  "3e2bb92dbc0d9fa495062e04c45cadd0f6d1558ca4573014646b2545a7e75531"
    sha256 cellar: :any,                 sonoma:        "e75525add2da8c086001cc6ba53912cc7eb05ea54d6483688bbb51560fb6f42c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e7616c4fd8896b946742a7057589823911d3e596f20d9fdc97dedeee2f9974f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97899d4d77263d40f8142ef6d72dc7bd836f55bff514bf1a6721b766ddcd9c1c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

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

class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-2.27.1.tgz"
  sha256 "8525b86d880ff217fa84d765dab81b3fd8b7abe0512ad7a6f30c890f092d259f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "835d63b685a5f14a19e4d709eeae18b9865b7e6cb567a9eca38c1072db3cae6f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "835d63b685a5f14a19e4d709eeae18b9865b7e6cb567a9eca38c1072db3cae6f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "835d63b685a5f14a19e4d709eeae18b9865b7e6cb567a9eca38c1072db3cae6f"
    sha256 cellar: :any_skip_relocation, sonoma:        "864932089a564d9cad2922ecc008c972f7021662357f46b2abf45a72fdb574c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a0c3df99d043b0bd7df2c7a9977b41ec78a83202fce661b5211c3b00937ce604"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9c4fc87f969d1eacb326d8a78392ad992b40be1969a80719a01a29bc8726893"
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

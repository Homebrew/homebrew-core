class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-2.20.2.tgz"
  sha256 "8c7879b6d96c3c0bdb14c68202debfbc8a52909efcaa5fb40e0397aa0772a605"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e5af3032138299fb82ebce6a80948d78ffe8705f8b2c067b168420c92edb7710"
    sha256 cellar: :any,                 arm64_sequoia: "590761948cacefe8a0d814f9d7f71ef6d8ed433e918745f5a659de819eefd50c"
    sha256 cellar: :any,                 arm64_sonoma:  "590761948cacefe8a0d814f9d7f71ef6d8ed433e918745f5a659de819eefd50c"
    sha256 cellar: :any,                 sonoma:        "6d8eccad09ff96a3af68f6ecc75ab8949e502d8d5a57050657dec6e9ab338499"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a90e9601389605182e417e1c1e19a3eb1177a0934d7fef571f26399214eb5c7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23846fc3ac45f55b078e725449329b6d794da97310cac6ab26adf80c26f5d9df"
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

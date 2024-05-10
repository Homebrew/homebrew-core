require "language/node"

class Basti < Formula
  desc "Securely connect to RDS, Elasticache, and other AWS resources in VPCs"
  homepage "https://github.com/basti-app/basti"
  url "https://registry.npmjs.org/basti/-/basti-1.6.2.tgz"
  sha256 "8d813c1f4e3b8195655d40e670aa8a2eb7dce2cd21d996564c56a3296163f1d7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ccdc225c3184b6626369992d27d9e9594f8681af7e42a2cba8b1f18270811666"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "235b7fa89efbc8c50ee85683bb46a4667c854cc8e8645145c435de9d6c559b90"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c6b4e79e74888bacf7586a11689b5e9f1f509fdb5be6bfaadc819e2ee0f8ff3"
    sha256 cellar: :any_skip_relocation, sonoma:         "1e00da4735be049ee43b2607c012bf4218273149ae2a20d379e2a9aa5be91db7"
    sha256 cellar: :any_skip_relocation, ventura:        "ca29d9563f42bdccc5b55dff60fc5403736ecc838957d4ac63644f1c4a18ce6a"
    sha256 cellar: :any_skip_relocation, monterey:       "79039c81499c954dac873a457c2e6bacdaab2bce1b2ff38ea208072bb4ade5f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22f542de0159104b75ad6b5251383cb629e280fbbe499545b43fd34efd7918b4"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binary, session-manager-plugin
    node_modules = libexec/"lib/node_modules/basti/node_modules"
    node_modules.glob("basti-session-manager-binary-*/*").each do |f|
      next if f.arch == Hardware::CPU.arch

      rm f
    end

    generate_completions_from_executable(bin/"basti", "completion",
                                            shells:                 [:bash, :zsh],
                                            shell_parameter_format: :none)
  end

  test do
    output = shell_output("#{bin}/basti cleanup")
    assert_match "No Basti-managed resources found in your account", output

    assert_match version.to_s, shell_output("#{bin}/basti --version")
  end
end

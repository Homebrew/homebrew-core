class Basti < Formula
  desc "Securely connect to RDS, Elasticache, and other AWS resources in VPCs"
  homepage "https://github.com/basti-app/basti"
  url "https://registry.npmjs.org/basti/-/basti-1.6.2.tgz"
  sha256 "8d813c1f4e3b8195655d40e670aa8a2eb7dce2cd21d996564c56a3296163f1d7"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e19564aeece7fc2749628f1b327717f0ed1aa365f52b40721aaa374aa3058074"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e19564aeece7fc2749628f1b327717f0ed1aa365f52b40721aaa374aa3058074"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e19564aeece7fc2749628f1b327717f0ed1aa365f52b40721aaa374aa3058074"
    sha256 cellar: :any_skip_relocation, sonoma:         "1e632db83fe49e15bf89f32d16d71a378b3a35107b4763a185a5f84636413c22"
    sha256 cellar: :any_skip_relocation, ventura:        "1e632db83fe49e15bf89f32d16d71a378b3a35107b4763a185a5f84636413c22"
    sha256 cellar: :any_skip_relocation, monterey:       "1e632db83fe49e15bf89f32d16d71a378b3a35107b4763a185a5f84636413c22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "907d5b4c78c66add943f6a57e448c559dcf182138ba6133d098b841093157f35"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
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

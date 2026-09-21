class ApifyCli < Formula
  desc "Apify command-line interface"
  homepage "https://docs.apify.com/cli/"
  url "https://registry.npmjs.org/apify-cli/-/apify-cli-1.10.0.tgz"
  sha256 "40322cc78c95f502e4995752bc9e7d53c6509204d6a94dc24b1f8ebc9174d2d5"
  license "Apache-2.0"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a9e93c1093d8b985b364a2ef67417625bcc212777a1bbf83a807f3dd2f0a843b"
    sha256 cellar: :any, arm64_tahoe:       "25b7521ea1b85820ca47954e7181e442bec8e40a7719975a9e043a31543fcdeb"
    sha256 cellar: :any, arm64_sequoia:     "25b7521ea1b85820ca47954e7181e442bec8e40a7719975a9e043a31543fcdeb"
    sha256 cellar: :any, arm64_sonoma:      "25b7521ea1b85820ca47954e7181e442bec8e40a7719975a9e043a31543fcdeb"
    sha256 cellar: :any, arm64_linux:       "1159db3511a97e46b265c9051de8759ec4cffbd4ab61c6b0afd15f334fd6aaa1"
    sha256 cellar: :any, x86_64_linux:      "2a2f52dc973dcd235e0e4b7f025df54ace5bb50693fe2b5a98f107d923ee4053"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/apify-cli/node_modules"

    # Remove incompatible pre-built `bare-fs`/`bare-path`/`bare-os`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-path,bare-os,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    output = shell_output("#{bin}/apify init -y testing-actor 2>&1")
    assert_includes output, "Success: The Actor has been initialized in the current directory"
    assert_path_exists testpath/"storage/key_value_stores/default/INPUT.json"

    assert_includes shell_output("#{bin}/apify --version 2>&1"), version.to_s
  end
end

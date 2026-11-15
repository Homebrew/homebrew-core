class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://www.asyncapi.com/tools/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-6.3.0.tgz"
  sha256 "62529a46a8bb232a8447f7400d8e68408e645ce9d4fbaf06e015dfa45549d521"
  license "Apache-2.0"
  version_scheme 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "79d6db48066d38f26c3517afcd319761b6b8fa270d37fdacc0973e378e1648eb"
    sha256 cellar: :any, arm64_tahoe:       "79d6db48066d38f26c3517afcd319761b6b8fa270d37fdacc0973e378e1648eb"
    sha256 cellar: :any, arm64_sequoia:     "79d6db48066d38f26c3517afcd319761b6b8fa270d37fdacc0973e378e1648eb"
    sha256 cellar: :any, arm64_linux:       "91eaf994b9f03e1cb702335c5eb03c7cc05b88807af6b732ccba3c8b1f840b13"
    sha256 cellar: :any, x86_64_linux:      "b1d484a48708587ed91ebfcc3ffaa2290e13257e55d076a28e47359c3e2ef59a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Replace universal binaries with their native slices
    node_modules = libexec/"lib/node_modules/@asyncapi/cli/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node"

    # Remove incompatible pre-built `bare-*` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("bare-{buffer,fs,path,os,url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    system bin/"asyncapi", "new", "file", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_path_exists testpath/"asyncapi.yml", "AsyncAPI file was not created"
  end
end

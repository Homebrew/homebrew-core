class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://www.asyncapi.com/tools/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-6.1.0.tgz"
  sha256 "ce731fd5c800548b0fbde4997e77008b4f379a5ba3790f398e1373d7eb9e60c8"
  license "Apache-2.0"
  version_scheme 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "c2e060de46dc2c5f7e8a49b5b4b7fc12d08ad31c2c7bf4b777623b2a4479276e"
    sha256 cellar: :any, arm64_tahoe:       "c2e060de46dc2c5f7e8a49b5b4b7fc12d08ad31c2c7bf4b777623b2a4479276e"
    sha256 cellar: :any, arm64_sequoia:     "c2e060de46dc2c5f7e8a49b5b4b7fc12d08ad31c2c7bf4b777623b2a4479276e"
    sha256 cellar: :any, arm64_linux:       "2d3589a3224e278e01133dec9a6ffd9879dbfa68368e91d3c4367bd6f707c504"
    sha256 cellar: :any, x86_64_linux:      "e90953cf0ae773c8397624b49bdbdb1a5f48bac1bbbb661bdf38863fbed2a944"
  end

  depends_on "node"

  def install
    # Set the log directory to var/log/asyncapi
    inreplace "lib/utils/logger.js", /const logDir = .*;/, "const logDir = '#{var}/log/asyncapi';"

    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Replace universal binaries with their native slices
    node_modules = libexec/"lib/node_modules/@asyncapi/cli/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node"

    # Remove incompatible pre-built `bare-fs`/`bare-os`/`bare-path`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os,bare-path,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    (var/"log/asyncapi").mkpath
  end

  test do
    system bin/"asyncapi", "new", "file", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_path_exists testpath/"asyncapi.yml", "AsyncAPI file was not created"
  end
end

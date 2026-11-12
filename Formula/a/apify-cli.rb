class ApifyCli < Formula
  desc "Apify command-line interface"
  homepage "https://docs.apify.com/cli/"
  url "https://registry.npmjs.org/apify-cli/-/apify-cli-1.12.0.tgz"
  sha256 "8df95135c12e62d162650da7bbfebd319945e0675675c641df0c7951256ba233"
  license "Apache-2.0"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a6a992096fdaf69583e78b2d44b1d0ff17986594618c01c25aba8776ae0fd324"
    sha256 cellar: :any, arm64_tahoe:       "a6a992096fdaf69583e78b2d44b1d0ff17986594618c01c25aba8776ae0fd324"
    sha256 cellar: :any, arm64_sequoia:     "a6a992096fdaf69583e78b2d44b1d0ff17986594618c01c25aba8776ae0fd324"
    sha256 cellar: :any, arm64_linux:       "dea21e8ca514e3981a3ce5b438253bab864af12686f7e6eea974a9baa3f36efe"
    sha256 cellar: :any, x86_64_linux:      "2831c5a29732bcee8161e867cea2281093568667fa307d5660485061babfd6bb"
  end

  depends_on "node"

  allow_network_access! :build

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/apify-cli/node_modules"

    # Remove incompatible pre-built `bare-fs`/`bare-path`/`bare-os`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-buffer,bare-fs,bare-path,bare-os,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    output = shell_output("#{bin}/apify init -y testing-actor 2>&1")
    assert_includes output, "Success: The Actor has been initialized in the current directory"
    assert_path_exists testpath/"storage/key_value_stores/default/INPUT.json"

    assert_includes shell_output("#{bin}/apify --version 2>&1"), version.to_s
  end
end

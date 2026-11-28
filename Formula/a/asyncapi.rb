class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://www.asyncapi.com/tools/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-6.3.1.tgz"
  sha256 "103f320aa2951cefd16ee58bda62736b42949b8d7a32b3c2434ca2daed27e600"
  license "Apache-2.0"
  version_scheme 1

  bottle do
    manifest_sha256 "f5548b350db152a17cde05fc4ca94a3eef4de48e2d545b797c25c217c266912e"
    sha256 cellar: :any, arm64_golden_gate: "20bb2e0778b5bee833f382208c1d605587f9ad5033f731c15759c14cb89a8ebc"
    sha256 cellar: :any, arm64_tahoe:       "20bb2e0778b5bee833f382208c1d605587f9ad5033f731c15759c14cb89a8ebc"
    sha256 cellar: :any, arm64_sequoia:     "20bb2e0778b5bee833f382208c1d605587f9ad5033f731c15759c14cb89a8ebc"
    sha256 cellar: :any, arm64_linux:       "37440290ba93999da0957e2ed97124dbe3081a259940b83a1362b2db6cf9e2bf"
    sha256 cellar: :any, x86_64_linux:      "c1727890ef860cc3ce7b8b7694daa32b89cc9f5d254fdcfa539110843084a352"
  end

  depends_on "node"

  allow_network_access! :build

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

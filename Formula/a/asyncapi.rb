class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://www.asyncapi.com/tools/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-6.2.3.tgz"
  sha256 "34f6f2e1de94dc4bb3ad558d91447eb037a488594927f5263c54223267f0e681"
  license "Apache-2.0"
  version_scheme 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "2a1534108af516b85fc817db00557b48b75acd58b233775d86d0ec22dd950158"
    sha256 cellar: :any, arm64_tahoe:       "2a1534108af516b85fc817db00557b48b75acd58b233775d86d0ec22dd950158"
    sha256 cellar: :any, arm64_sequoia:     "2a1534108af516b85fc817db00557b48b75acd58b233775d86d0ec22dd950158"
    sha256 cellar: :any, arm64_linux:       "5dad1fd78578828f99c1f517e0712505e97d40677e91bfeaa60f418525c69f8d"
    sha256 cellar: :any, x86_64_linux:      "f6174a7accf7b153deeb578764196603c307d768b26248379f8fa7e4ac51813d"
  end

  depends_on "node"

  def install
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
  end

  test do
    system bin/"asyncapi", "new", "file", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_path_exists testpath/"asyncapi.yml", "AsyncAPI file was not created"
  end
end

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-6.0.2.tgz"
  sha256 "25ecd3a3c04cf47158bf4572136c3f95aface7c0df63a1c9ab8930c9ee7b7258"
  license "Apache-2.0"
  version_scheme 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "cba3743eb9834bf40e238097d40f5b78972e7e0bc057f097a9227a9c09128b9a"
    sha256 cellar: :any, arm64_sequoia: "14a8493220875fdbfe09991fc0439df95a0df61ea0829759f8b26772018af3b8"
    sha256 cellar: :any, arm64_sonoma:  "14a8493220875fdbfe09991fc0439df95a0df61ea0829759f8b26772018af3b8"
    sha256 cellar: :any, sonoma:        "f7bbe2a92d7b4991feb047276694c1bec6b863380d46beb8868f3b64d631d871"
    sha256 cellar: :any, arm64_linux:   "77ee2374e17b18baaf325dfc841d7e6e9a02e6977e9d33ad07b849a0fc2cc1dd"
    sha256 cellar: :any, x86_64_linux:  "9149c8c6629dc5f6019056a8ca416c3a95de0fa3e772d73703f3d4f5824ad582"
  end

  depends_on "node"

  def install
    # Set the log directory to var/log/asyncapi
    inreplace "lib/utils/logger.js", /const logDir = .*;/, "const logDir = '#{var}/log/asyncapi';"

    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Cleanup .pnpm folder
    node_modules = libexec/"lib/node_modules/@asyncapi/cli/node_modules"
    rm_r (node_modules/"@asyncapi/studio/build/standalone/node_modules/.pnpm") if OS.linux?

    # Replace universal binaries with their native slices
    deuniversalize_machos node_modules/"fsevents/fsevents.node"

    # Remove incompatible pre-built `bare-fs`/`bare-os`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    (var/"log/asyncapi").mkpath
  end

  test do
    system bin/"asyncapi", "new", "file", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_path_exists testpath/"asyncapi.yml", "AsyncAPI file was not created"
  end
end

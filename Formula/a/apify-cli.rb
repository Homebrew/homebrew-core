class ApifyCli < Formula
  desc "Apify command-line interface"
  homepage "https://docs.apify.com/cli/"
  url "https://registry.npmjs.org/apify-cli/-/apify-cli-1.8.0.tgz"
  sha256 "4943f2ae52bd2c37c6c283a205c415790f2e4ba0fdbfb90b1f5fcd6e0fabeed1"
  license "Apache-2.0"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "cbb446d0d31801c2d50fdf3ad26a038a1e40e8bb642c322dbe4054a6ec72cd5b"
    sha256 cellar: :any, arm64_sequoia: "cbb446d0d31801c2d50fdf3ad26a038a1e40e8bb642c322dbe4054a6ec72cd5b"
    sha256 cellar: :any, arm64_sonoma:  "cbb446d0d31801c2d50fdf3ad26a038a1e40e8bb642c322dbe4054a6ec72cd5b"
    sha256 cellar: :any, sonoma:        "db976c473733bab5259cf5740d9dadb21be06525970454c4dd3143ac85148c42"
    sha256 cellar: :any, arm64_linux:   "4b48e9c48407932352bf71c0ffc06dbbb96bc9c3d935d25254be7dd510a4a65b"
    sha256 cellar: :any, x86_64_linux:  "a94db10b8a8546b14eef7bf57f5ca214cea4bc9172a5a4564f66fa9378919a59"
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

class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.105.tgz"
  sha256 "2f5a348c9f6cb2322ef7985062334a0c84cda60587b20cfec57995f434e18ecb"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "f55c48e03cf29fc652273845003493ac29fb58add6ad7a8a65ca30402cf872aa"
    sha256                               arm64_sequoia: "f55c48e03cf29fc652273845003493ac29fb58add6ad7a8a65ca30402cf872aa"
    sha256                               arm64_sonoma:  "f55c48e03cf29fc652273845003493ac29fb58add6ad7a8a65ca30402cf872aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b4cf9fb8be1668a988a7b42cfc656d2dca6414fca13b468263c3eb95709e7bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "245200caffe3e09fa304bb9b2999f7671f48143731f5b96e2802706ff0422be5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04ee4c13b9a1968057f670003b31169dc3969172e8f325028f527528e84f138c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove binaries for other architectures, `-musl`, `-baseline`, and `-baseline-musl`
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    os = OS.linux? ? "linux" : "darwin"
    (libexec/"lib/node_modules/opencode-ai/node_modules").children.each do |d|
      next unless d.directory?

      rm_r d if d.basename.to_s != "opencode-#{os}-#{arch}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opencode --version")
    assert_match "opencode", shell_output("#{bin}/opencode models")
  end
end

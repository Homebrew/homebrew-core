class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.5.10.tgz"
  sha256 "d4a6467f01faf01ffd18636e4a951051149638e675d9633b5cbfc0a6da93b4cf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "19f0e83d0b4f3659d6b7a2368ca3be0ed34e404cfbc3015934b4dc64258df6d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1a08538caafafa12c2998f1b3ba375eef03d97059e801c08e5b3ea322dfc46e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1a08538caafafa12c2998f1b3ba375eef03d97059e801c08e5b3ea322dfc46e"
    sha256 cellar: :any_skip_relocation, sonoma:        "daed58f5493112dde891aa656fd51587026f4ba4f4e24f0e076604dea950ed3c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ab992392f5445a6b674bff7f463bf9ca88faee4b18358dc1f7fd4cde105954a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ab992392f5445a6b674bff7f463bf9ca88faee4b18358dc1f7fd4cde105954a"
  end

  depends_on "node"
  uses_from_macos "zlib"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    node_modules = libexec/"lib/node_modules/cubejs-cli/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_path_exists testpath/"hello-world/model/cubes/orders.yml"
  end
end

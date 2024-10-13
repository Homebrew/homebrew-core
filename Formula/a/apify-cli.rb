class ApifyCli < Formula
  desc "Apify command-line interface"
  homepage "https://docs.apify.com/cli"
  url "https://registry.npmjs.org/apify-cli/-/apify-cli-0.20.9.tgz"
  sha256 "179e6f1543d2149af82e3cba4c4bd3e7cfaa872506c0df902d5714689a9ae1c3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42d08e6d26dd93e1fa2cfb9147f1fcc10f886f0b7acf2fa56533a201107f3d39"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42d08e6d26dd93e1fa2cfb9147f1fcc10f886f0b7acf2fa56533a201107f3d39"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "42d08e6d26dd93e1fa2cfb9147f1fcc10f886f0b7acf2fa56533a201107f3d39"
    sha256 cellar: :any_skip_relocation, sonoma:        "0994cc43fc123fddfc4df322d1fc7a46ece484f26dbda0a73062d3d2342dcdb3"
    sha256 cellar: :any_skip_relocation, ventura:       "0994cc43fc123fddfc4df322d1fc7a46ece484f26dbda0a73062d3d2342dcdb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9dbb57de9c2892b982e2d73d247696ed9304fd19b12b6f36b1a0ee9cfd5b84f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/apify init -y testing-actor 2>&1")
    assert_includes output, "Success: The Actor has been initialized in the current directory"
    assert_predicate testpath/"storage/key_value_stores/default/INPUT.json", :exist?

    assert_includes shell_output("#{bin}/apify --version 2>&1"), version.to_s
  end
end

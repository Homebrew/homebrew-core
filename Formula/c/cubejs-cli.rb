require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.35.49.tgz"
  sha256 "2b99c9bb2e24215ccca9655a0feb21cec10d078bf6dfce51878d9aab7d81c1d9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d3ef558549a3985715333976db39ed8cbc058fb32c132baae83751817761b5ed"
    sha256 cellar: :any,                 arm64_ventura:  "d3ef558549a3985715333976db39ed8cbc058fb32c132baae83751817761b5ed"
    sha256 cellar: :any,                 arm64_monterey: "d3ef558549a3985715333976db39ed8cbc058fb32c132baae83751817761b5ed"
    sha256 cellar: :any,                 sonoma:         "26f22bfe63c46e4407f2c0cbf6ca128d6b7c642ddae2af2a650d31ceacf260b9"
    sha256 cellar: :any,                 ventura:        "26f22bfe63c46e4407f2c0cbf6ca128d6b7c642ddae2af2a650d31ceacf260b9"
    sha256 cellar: :any,                 monterey:       "26f22bfe63c46e4407f2c0cbf6ca128d6b7c642ddae2af2a650d31ceacf260b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "320b7865bee79fb27d2f4fb9d82c7432f41c6978eec9d8a037092217aea043bf"
  end

  depends_on "node"
  uses_from_macos "zlib"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/model/cubes/orders.yml", :exist?
  end
end

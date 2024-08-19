class ChalkCli < Formula
  desc "Terminal string styling done right"
  homepage "https://github.com/chalk/chalk-cli"
  url "https://registry.npmjs.org/chalk-cli/-/chalk-cli-5.0.1.tgz"
  sha256 "17befe5108e2fd64661305b4f1d7378dfdb2f34ae4e1bba6d895ff427b7b4286"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6dd72ec4c56bdaf68b01d37300b2535c23b69a539ab796d27136640ac072f6b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6dd72ec4c56bdaf68b01d37300b2535c23b69a539ab796d27136640ac072f6b5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6dd72ec4c56bdaf68b01d37300b2535c23b69a539ab796d27136640ac072f6b5"
    sha256 cellar: :any_skip_relocation, sonoma:         "6dd72ec4c56bdaf68b01d37300b2535c23b69a539ab796d27136640ac072f6b5"
    sha256 cellar: :any_skip_relocation, ventura:        "6dd72ec4c56bdaf68b01d37300b2535c23b69a539ab796d27136640ac072f6b5"
    sha256 cellar: :any_skip_relocation, monterey:       "6dd72ec4c56bdaf68b01d37300b2535c23b69a539ab796d27136640ac072f6b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea570e06f25667aeceac64b1434ddc5bafdc21ecd5147ba46fd102b3a7ee9498"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "hello, world!", pipe_output("#{bin}/chalk bold cyan --stdin", "hello, world!")
  end
end

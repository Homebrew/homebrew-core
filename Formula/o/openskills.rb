class Openskills < Formula
  desc "Universal skills loader for AI coding agents"
  homepage "https://github.com/numman-ali/openskills"
  url "https://registry.npmjs.org/openskills/-/openskills-1.5.0.tgz"
  sha256 "2aa0c31c2a09fad8c32705d519a5497aa671381189bde9d8f7911a7967a9d9bc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e2026c6d2ec9ba496ba0be75a24794d328cb23cfd8ede1922f0be3b1a81da9e8"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/openskills --version")
    assert_match "No skills installed", shell_output("#{bin}/openskills list")
  end
end

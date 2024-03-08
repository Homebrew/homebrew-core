require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-1.6.1.tgz"
  sha256 "f186f5ecd23ea6b00565c030b3e54361a094b2bc99a8279baad5337f4931f921"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2d063ed69fff9a0451955d4e52a4db3362327daa1f3d1ffbb9fb9adac062c447"
    sha256 cellar: :any,                 arm64_ventura:  "2d063ed69fff9a0451955d4e52a4db3362327daa1f3d1ffbb9fb9adac062c447"
    sha256 cellar: :any,                 arm64_monterey: "2d063ed69fff9a0451955d4e52a4db3362327daa1f3d1ffbb9fb9adac062c447"
    sha256 cellar: :any,                 sonoma:         "f9f8f7681bf14b9d5874743adf2e07e2eafbb8bda1ae51723d8af94d8064d3d2"
    sha256 cellar: :any,                 ventura:        "f9f8f7681bf14b9d5874743adf2e07e2eafbb8bda1ae51723d8af94d8064d3d2"
    sha256 cellar: :any,                 monterey:       "f9f8f7681bf14b9d5874743adf2e07e2eafbb8bda1ae51723d8af94d8064d3d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "827104b6df90ef754fa1928d667a4e1bce8d392808c5f67b6638bd461c29d471"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    system bin/"asyncapi", "new", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_predicate testpath/"asyncapi.yml", :exist?, "AsyncAPI file was not created"
  end
end

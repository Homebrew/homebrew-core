require "language/node"

class Czg < Formula
  desc "Interactive Commitizen CLI that generate standardized commit messages"
  homepage "https://github.com/Zhengqbbb/cz-git"
  url "https://registry.npmjs.org/czg/-/czg-1.9.0.tgz"
  sha256 "8e96bc2b496e72c9db3d63c35cdfeb7a97993be55a614496db43705f915f8ba5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ea7b9941920d50bdafb12a7dd7baaf626e0501a9c2b62a3586ca5a64c381707d"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal "#{version}\n", shell_output("#{bin}/czg --version")
    # test: git staging verifies is working
    system "git", "init"
    assert_match ">>> No files added to staging! Did you forget to run `git add` ?",
      shell_output("NO_COLOR=1 #{bin}/czg 2>&1", 1)
  end
end

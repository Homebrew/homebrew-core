require "language/node"

class Prettier < Formula
  desc "Code formatter for JavaScript, CSS, JSON, GraphQL, Markdown, YAML"
  homepage "https://prettier.io/"
  url "https://registry.npmjs.org/prettier/-/prettier-2.8.5.tgz"
  sha256 "db38b82601756eb0f9ef32c7e59214d03830645a7293cebeab758614f2ba9845"
  license "MIT"
  head "https://github.com/prettier/prettier.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1244bef7e5fc401fce7daa778a7c7c64535df04e7ea5b6ff9df56142a6d31c1f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73ac9e0be956612c3c8ca944441aade77120343619726ae90e08c0ca00798af9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "52ce9fdc38257d8ae27a4014bedfdf19d0599bf2503df970f7e5faecd473a0c2"
    sha256 cellar: :any_skip_relocation, ventura:        "eef46dc682cf848a64448437a3263e694f8ad5563db52417c395be8d2667209f"
    sha256 cellar: :any_skip_relocation, monterey:       "7e993bdb53f347d5204d723a33dd0747f7ddba976d88c6e85e67333e1fb5d1f4"
    sha256 cellar: :any_skip_relocation, big_sur:        "e72f9f7724e702b7c9f0580484d02f54f4634bb4d3e081af3edfb972c08abed2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5438e28643fbde45c668386f9dde46221992233470e423b5c72920dcfc882a85"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.js").write("const arr = [1,2];")
    output = shell_output("#{bin}/prettier test.js")
    assert_equal "const arr = [1, 2];", output.chomp
  end
end

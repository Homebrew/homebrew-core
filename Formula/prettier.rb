require "language/node"

class Prettier < Formula
  desc "Code formatter for JavaScript, CSS, JSON, GraphQL, Markdown, YAML"
  homepage "https://prettier.io/"
  url "https://registry.npmjs.org/prettier/-/prettier-1.16.1.tgz"
  sha256 "edc703b6986ea140f615bc3dda59ecf994712e33a1c054d91e7681cf7c11603c"

  bottle do
    cellar :any_skip_relocation
    sha256 "9c58623d31b4af00142b57b681052d88fb0b5157d90a8de2ef33d88484df0cf6" => :mojave
    sha256 "6f13c267100cc32e4cae82863d0702f8e0280740f3a44e0a83ef73e8964c49e2" => :high_sierra
    sha256 "8eeb4ca102daa1612484c8b29ea4d5c9dfc8bd3438aa3e4c085d04320bd8cc23" => :sierra
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

require "language/node"

class Prettier < Formula
  desc "Code formatter for JavaScript, CSS, JSON, GraphQL, Markdown, YAML"
  homepage "https://prettier.io/"
  url "https://registry.npmjs.org/prettier/-/prettier-2.0.5.tgz"
  sha256 "6d8af960b3a47645bc897da4bbbf6923de82f7809990cf44e8e4d8077828893f"
  head "https://github.com/prettier/prettier.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "574dda64087b9a45f5f62f43da87f6874748c908a4f87ed02d90b10d1badcade" => :catalina
    sha256 "6983cf4b630f60456c411f46c44560a3df82c822ca3fe47336979903f528356f" => :mojave
    sha256 "7f62f204a42a3b8093820068b636e142f184219f4308eeca3639eab78bc3866d" => :high_sierra
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

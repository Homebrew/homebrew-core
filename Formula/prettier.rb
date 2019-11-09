require "language/node"

class Prettier < Formula
  desc "Code formatter for JavaScript, CSS, JSON, GraphQL, Markdown, YAML"
  homepage "https://prettier.io/"
  url "https://registry.npmjs.org/prettier/-/prettier-1.19.0.tgz"
  sha256 "5c116112496b575213caa801901104a1d865af278496c1726d0173b47e2fb2be"
  head "https://github.com/prettier/prettier.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f8f40e33504c868c3b227e2401b6492b0c6c136fd10433e1cb7b6143009a0ca2" => :catalina
    sha256 "8a3f035beb5bf878e350a5071d68fb148698cf42c33a5f0f2855cb3358d755bb" => :mojave
    sha256 "26573d67e45bef92017a7ce795e8cd794a1677745692e710e122d756e2e4d2c5" => :high_sierra
    sha256 "9f76f5d2d41a661c9bbc6df1c46fb074d1d720286ef79be3f3b1a5c8ea43e7d4" => :sierra
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

require "language/node"

class Coffeescript < Formula
  desc "Unfancy JavaScript"
  homepage "http://coffeescript.org"
  url "https://registry.npmjs.org/coffee-script/-/coffee-script-1.12.5.tgz"
  sha256 "caa67ae9689b58a7005760fb869d7b4e7c6b785e5f6934c3eee8673669a75394"
  head "https://github.com/jashkenas/coffeescript.git", :branch => "2"

  bottle do
    cellar :any_skip_relocation
    sha256 "ac3ec0e5d05b40a3a6023449ff96fdf313569128cc2fd1079e68faba90101123" => :sierra
    sha256 "951cbca1a5cee5c23d388259cf1a8e81deff342ad0482d43dfe9da190a8774ff" => :el_capitan
    sha256 "8d4fca05564928080b06fe2c2567eced775cc3548094f06014f50f251c45442e" => :yosemite
  end

  devel do
    url "https://registry.npmjs.org/coffeescript/-/coffeescript-2.0.0-alpha1.tgz"
    sha256 "6de0bb53bf3c98fab8151af7c4e2bb5a258f276d7bee1d5374b7a038557c39df"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.coffee").write <<-EOS.undent
      square = (x) -> x * x
      list = [1, 2, 3, 4, 5]

      math =
        root:   Math.sqrt
        square: square
        cube:   (x) -> x * square x

      cubes = (math.cube num for num in list)
    EOS

    system bin/"coffee", "--compile", "test.coffee"
    assert File.exist?("test.js"), "test.js was not generated"
  end
end

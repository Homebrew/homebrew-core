require "language/node"

class Coffeescript < Formula
  desc "Unfancy JavaScript"
  homepage "http://coffeescript.org"
  url "https://registry.npmjs.org/coffeescript/-/coffeescript-2.2.3.tgz"
  sha256 "cb23148f7c145af6bac39e58cf4d1958d32b2ab4abb3768b18f4578d9e8cc41d"
  head "https://github.com/jashkenas/coffeescript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "34e990294825fec63ef49227243bbb60f2396f8757b3f82bcca7c8fc9190733d" => :high_sierra
    sha256 "62a39e9c5b4b7aff52ea7ae477d2af8f8126f74807aec7547e1e4a2ed36e9b43" => :sierra
    sha256 "deb8596d8c296dc0ea2c19b8d69e8993de16a2f269047575b55fd2722942f61e" => :el_capitan
  end

  depends_on "node"

  conflicts_with "cake", :because => "both install `cake` binaries"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.coffee").write <<~EOS
      square = (x) -> x * x
      list = [1, 2, 3, 4, 5]

      math =
        root:   Math.sqrt
        square: square
        cube:   (x) -> x * square x

      cubes = (math.cube num for num in list)
    EOS

    system bin/"coffee", "--compile", "test.coffee"
    assert_predicate testpath/"test.js", :exist?, "test.js was not generated"
  end
end

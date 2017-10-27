require "language/node"

class Coffeescript < Formula
  desc "Unfancy JavaScript"
  homepage "http://coffeescript.org"
  url "https://registry.npmjs.org/coffeescript/-/coffeescript-2.0.2.tgz"
  sha256 "9e05f914f881b2b37ff2f7baa210a070f79e2b56c79f2ca3029f1a5e25f9612c"
  head "https://github.com/jashkenas/coffeescript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1473d7045a5adb7e08ab8e7b4d67be86357b3c225752d924f988887412fe4626" => :high_sierra
    sha256 "62c452c8b907278cdcf12d36be2c3ff1c3de3d5647eb2447acc3fee2f50b2669" => :sierra
    sha256 "94bb7cc930371190cec01501f6a28471022f00fccc7d378d88e0a3b6d0635f5f" => :el_capitan
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

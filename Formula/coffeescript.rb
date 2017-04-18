require "language/node"

class Coffeescript < Formula
  desc "Unfancy JavaScript"
  homepage "http://coffeescript.org"
  url "https://registry.npmjs.org/coffee-script/-/coffee-script-1.12.5.tgz"
  sha256 "caa67ae9689b58a7005760fb869d7b4e7c6b785e5f6934c3eee8673669a75394"
  head "https://github.com/jashkenas/coffeescript.git", :branch => "2"

  bottle do
    cellar :any_skip_relocation
    sha256 "bfb5cb719d9eb5bac426edf8ae2b3ed08da898c80b6c43c83be0d510edf4ed83" => :sierra
    sha256 "22c5f53e1790a73f34fea0f2bb7c094796b031ff33dcf6a7c897a27bf9b44af8" => :el_capitan
    sha256 "b1940f95c27a23782fc443b82b88539574adb6a6584974212941755432ff4e48" => :yosemite
  end

  devel do
    url "https://registry.npmjs.org/coffeescript/-/coffeescript-2.0.0-beta1.tgz"
    sha256 "9976d3f9594209bcfbedfe290abcc3a8ec8767f698425cfd2bc1419a6e5589a7"
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

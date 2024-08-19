class Coffeescript < Formula
  desc "Unfancy JavaScript"
  homepage "https://coffeescript.org/"
  url "https://registry.npmjs.org/coffeescript/-/coffeescript-2.7.0.tgz"
  sha256 "590e2036bd24d3b54e598b56df2e0737a82c2aa966c1020338508035f3b4721f"
  license "MIT"
  head "https://github.com/jashkenas/coffeescript.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8e07f15b72bb3182536806a3ca9449a40fa7957d6501c5f7c20e38a5bc96c219"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8e07f15b72bb3182536806a3ca9449a40fa7957d6501c5f7c20e38a5bc96c219"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e07f15b72bb3182536806a3ca9449a40fa7957d6501c5f7c20e38a5bc96c219"
    sha256 cellar: :any_skip_relocation, sonoma:         "8e07f15b72bb3182536806a3ca9449a40fa7957d6501c5f7c20e38a5bc96c219"
    sha256 cellar: :any_skip_relocation, ventura:        "8e07f15b72bb3182536806a3ca9449a40fa7957d6501c5f7c20e38a5bc96c219"
    sha256 cellar: :any_skip_relocation, monterey:       "8e07f15b72bb3182536806a3ca9449a40fa7957d6501c5f7c20e38a5bc96c219"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7454fcd2bd55ba72481506195de985a7ad153ab63cd8f41e1204e69a81467253"
  end

  depends_on "node"

  conflicts_with "cake", because: "both install `cake` binaries"

  def install
    system "npm", "install", *std_npm_args
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

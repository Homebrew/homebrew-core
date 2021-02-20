require "language/node"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/jiahaog/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-42.2.1.tgz"
  sha256 "97011d32878e7a6a69e827846f023e7aa2975976c5fc984d250f9dcd0d8f1f0c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f71acf0783b0ddf74e5abbd3629523a544b59d93e055c7e4aea82564150e9061"
    sha256 cellar: :any_skip_relocation, big_sur:       "cea457857fb8fd4ad9f11dd58b1f05fef3492a92fae9f035f1bbcb4cb7654b85"
    sha256 cellar: :any_skip_relocation, catalina:      "1ae78ba9ea9d12a774e8d9d3469cec057f36f1844f650fdc42a82a23b4edba31"
    sha256 cellar: :any_skip_relocation, mojave:        "87fa08ca1b96147f847af4d2ca1f598a6ee11e2db42d56a832f4d052638f3145"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nativefier --version")
  end
end

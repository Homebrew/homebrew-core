require "language/node"

class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.62.1.tgz"
  sha256 "cba81ae45901d5d33c2068d737f201ddea56a6dcc9fab56ae929077397d136db"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "342c8bc83b3c66f87a4d01c9303459f11db7dacaa35b9cc13c63cd94671e5f36"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8995fe313e9a28746d32a6529d7b72d1d00283ba0719cd8a10119427b4c1b6ca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a1f5ade3d94351f6c987469d0759cec028a9fdaa98584e3d1f3efafcb6292f0c"
    sha256 cellar: :any_skip_relocation, sonoma:         "6df2a1755f140b3a0944c1941e5daa35490fb13ab0bb766e1468b0dbf6803fce"
    sha256 cellar: :any_skip_relocation, ventura:        "1575d93bcc7f74c3bc69859226d374507dd45e6a057d23960a93cd253ab9dd45"
    sha256 cellar: :any_skip_relocation, monterey:       "148a1c07a372cc9ea1f258774e74bdf1c1a72b73e6c7126182c0db245b958ef2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a010d411c23c6b3439d1cc6f15c0ac48ae603765f5a17fb8a0dc609d7e2966b"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"promptfoo", "init"
    assert_predicate testpath/".promptfoo", :exist?
    assert_match "description: 'My first eval'", (testpath/"promptfooconfig.yaml").read

    assert_match version.to_s, shell_output("#{bin}/promptfoo --version", 1)
  end
end

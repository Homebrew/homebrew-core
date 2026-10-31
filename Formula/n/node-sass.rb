class NodeSass < Formula
  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.107.1.tgz"
  sha256 "e983e8e3ecfa2d15fc67ae0aa613a68aecc27c30cfa141b1fb1b7ca07a288faa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "62adeda8e23cd159aa227a79076f1b0613e2cd2845fe2128b7b9907284095d64"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "62adeda8e23cd159aa227a79076f1b0613e2cd2845fe2128b7b9907284095d64"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "62adeda8e23cd159aa227a79076f1b0613e2cd2845fe2128b7b9907284095d64"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e0109ba78dad6c60185e7cc1ed4dca2eae3e5c0f3d7b6522403251494d7c9a90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "fc8569ba8f698a211d137e298ecf3eccc4663b76572492aff67da7774a26aab7"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"test.scss").write <<~SCSS
      div {
        img {
          border: 0px;
        }
      }
    SCSS

    assert_equal "div img{border:0px}",
    shell_output("#{bin}/sass --style=compressed test.scss").strip
  end
end

class NodeSass < Formula
  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.87.0.tgz"
  sha256 "ee830f79071bcaf00c47d21366b25490eb7cfb1e024bb72106813b6060412f0e"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "88f940caf643d209b6e3c99944bafbcda5780688ddfd7ac15081c82f20bb2c1d"
    sha256                               arm64_sonoma:  "52210a3b4730d4fae586b530af958ea1de474755d55ddec34afa70a15f7dd1d1"
    sha256                               arm64_ventura: "0c5ee075755227b7815721187cbec2a7403286d6c1b782f7b54af813260b2151"
    sha256                               sonoma:        "dce846dd3df911f30142f3202be5eb0c490e85e23234a0b567fc5fa9d1cbe6db"
    sha256                               ventura:       "e6ee4d4062a9178b06736bd8ea1646e0b97b600161292f0795703c40741a2fa1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "771939fe14146b5e642d6e616532ce234a239ba8368c2badb898399a28b8eeb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b982ccd48ba47429ea7c2db9e73ef88365c69c9a6b75c375bb30ac8109f9917"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.scss").write <<~EOS
      div {
        img {
          border: 0px;
        }
      }
    EOS

    assert_equal "div img{border:0px}",
    shell_output("#{bin}/sass --style=compressed test.scss").strip
  end
end

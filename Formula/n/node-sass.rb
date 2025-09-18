class NodeSass < Formula
  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.92.1.tgz"
  sha256 "757e6d7d79b328b9600351ee825cca95f0d38bdeee9f8dc8f4ead6a50c46433e"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "a48e559f0f22395ff7c7658bf9a250a12245b7b16951f6de0a58648e5671a0d4"
    sha256                               arm64_sequoia: "2626c6d46b1e41aa9bf0ce7d20ddfaca813c24a6b62cf163dfefeb63fdddee18"
    sha256                               arm64_sonoma:  "68d4c40ba4d5ac4f5b694cb5b58b0310cf7395d2f9f02636587947442186531d"
    sha256                               arm64_ventura: "57872ae88543fe0b503431706eceb99e566945c97a46a55d2364442b4b61efde"
    sha256                               sonoma:        "57c67dd5d5288217d68a0438800bafe90dd157fe1c59b3ae3086d84fb72f69e4"
    sha256                               ventura:       "7aaddcda63afd5a49aea4c4425a87ad3f4a42e0d25cf91f8e64c02ed7f6176fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "952a002f0150fde416498b8b6894d69b3129eda99a6a5b6898d92dcd86f91507"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a95b4fc74c3df03e08c6d82863e0167627285dabf4c215c4cd2d3187abd6d67"
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

class NodeSass < Formula
  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.94.2.tgz"
  sha256 "81918102fe314ba5888d377d4f4786b5ed9bfd2593ce31d7354f8802eb7defe5"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "2b850c01351a3a72e4ed5a277e77aff60af0d9626160ab519d05f2fb97bea63d"
    sha256                               arm64_sequoia: "3ad6af6a4806b01c394b862431ad5bb1e88b474d109dec0f75141f9c32ba6ccf"
    sha256                               arm64_sonoma:  "1af47ee1a66ad938c8b785159e30b6bb8177adac0075ef36b3f406017dc7acb0"
    sha256                               sonoma:        "8bcc083f38e4992861d9e1e1f3e85ddd96a0f346985450a3a6f5df7f1c01e1ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f119ebcf7ba990f40526fafa9844a9b5f63b2cd7a7296085176ac244fe974571"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d04bc22601fb3cd31c68bb613ba7168313de17caf86aca0acf66627bc76b16ba"
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

class NodeSass < Formula
  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.105.2.tgz"
  sha256 "185160e7706228c298ff7ea9840ad7a1edf234d42e3cbb53665b4e6bfc869368"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ff38697cdf86aac288577b1055ddd5951b748c36c7e5656d0da50f93210e348c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ff38697cdf86aac288577b1055ddd5951b748c36c7e5656d0da50f93210e348c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ff38697cdf86aac288577b1055ddd5951b748c36c7e5656d0da50f93210e348c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "40a420e8f2c1f4d6f8a35c936325ee873c045da77abe4e8eea59e2f5f66440dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "8fa728c126821954c5f8b856c1f84c789fbe8c19e86a71596671c46342c45e32"
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

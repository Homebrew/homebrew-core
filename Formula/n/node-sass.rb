class NodeSass < Formula
  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.104.1.tgz"
  sha256 "7a935a71c27e77910a61fe079641b034ac11aaf2b30071e338f9948d9fe871d7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "192a34cad562f4d774e4b2806b7ca2f89376dee4fd7cd03903cc6f00ae036108"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "192a34cad562f4d774e4b2806b7ca2f89376dee4fd7cd03903cc6f00ae036108"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "192a34cad562f4d774e4b2806b7ca2f89376dee4fd7cd03903cc6f00ae036108"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "06eff50cfebe5b528698735aedcf83188059e825e22db7be875b15dc87c1cd6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "859060e829be4986aa8ffb783e914a84d09d302b060db24654f58f8a09d375da"
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

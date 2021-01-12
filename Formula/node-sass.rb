class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.32.3.tgz"
  sha256 "d59343da94a339aa65f8cd9cb27ab8b734ae0f5cd5ec5fd8e6e470a222017883"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "7d2b02fe52172253371ca96a0579e86964432125e3d2f710b41681ad05a416fd" => :big_sur
    sha256 "e82a04861673b29053e2e4d923413426e70ee008005c253ff1188457b39b25b9" => :arm64_big_sur
    sha256 "d3cc05f1333e11fbe51833f671dd6cc22ae64c0594af3383c1da7cfd513806c8" => :catalina
    sha256 "5b4dcfe8d1190476f19b3a062ab3089fc50ea5ed7bd6492f2888e2347af4f987" => :mojave
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
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

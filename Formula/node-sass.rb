class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.26.3.tgz"
  sha256 "d346a5b9b02680b4cd2440346ec3ff099d3c7d738524620196601915bc57992a"

  bottle do
    cellar :any_skip_relocation
    sha256 "6fc51b803486053e68488f18079177a53bb94274021846083718a7f53e26f064" => :catalina
    sha256 "e6c0e60f77cb3b97cdfcc4f9b34a817aaf70064f7bf005bcaa4b66d9a1c2454a" => :mojave
    sha256 "7c282f5061c87f4f8fd7c4ada4c5b461ac91e83d35c90defe336c87489549d21" => :high_sierra
  end

  depends_on "node"

  # waiting for pull request at #47438
  # conflicts_with "dart-sass", :because => "both install a `sass` binary"

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

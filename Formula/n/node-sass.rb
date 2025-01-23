class NodeSass < Formula
  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.83.4.tgz"
  sha256 "04dfdce75ec4fc0f4b86f7a04d69dd05ccaa8ec86c79d0145129b9389f253b65"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "8163870a4470b4c142ff63ee78a681be32204f5b665b20170818121cf206b7fe"
    sha256                               arm64_sonoma:  "409796c3cbb72532b42aa815a74cae473773a2de2441d6f0059f93a53a34ce3c"
    sha256                               arm64_ventura: "8581c28d8a4a8f584f39f116d4676d84afc7f47a201c85537fc6672af52565d7"
    sha256                               sonoma:        "7170bdfa3354bf732cf8bcd1288c213429aae638610e1768f2a640a3e4856227"
    sha256                               ventura:       "4de5d47b865743be1dc633d3c861ee4e8ec00f7082838ba151df67e0228654bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86c13ee2d163ff5c405982908a309f04382685fe509ce5bfa388c5d22e18375c"
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

require "language/node"

class Charge < Formula
  desc "Opinionated, zero-config static site generator"
  homepage "https://charge.js.org"
  url "https://registry.npmjs.org/@static/charge/-/charge-1.7.0.tgz"
  sha256 "477e6eb2a5d99854b4640017d85ee5f4ea09431a2ff046113047764f64d21ab5"
  license "MIT"
  head "https://github.com/brandonweiss/charge.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "b6b02c7658ca9d8c8211554a74d399f5a9188f516e152fb7eee5a2b879d050d3" => :catalina
    sha256 "f2d73159f3331a3c7a6126eb7054fb987abf89598521fad3dece201f06cbf79d" => :mojave
    sha256 "2dcccfe026217c62a72db3ff501ee56c1c8216e5f00e567ca12706aaddb6ea8b" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"src/index.html.jsx").write <<~EOS
      import Component from "./component.html.jsx"

      export default () => {
        return <Component message="Hello!" />
      }
    EOS

    (testpath/"src/component.html.jsx").write <<~EOS
      export default (props) => {
        return <p>{props.message}</p>
      }
    EOS

    system bin/"charge", "build", "src", "out"
    assert_predicate testpath/"out/index.html", :exist?
  end
end

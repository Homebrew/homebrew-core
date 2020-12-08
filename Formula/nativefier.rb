require "language/node"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/jiahaog/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-42.0.2.tgz"
  sha256 "bdea516de445deabcd7e1decb7e69a7f2153f78173e08afda212918a05c590f2"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "b3d7be571ba619a053767c3240fb8dc71dd865c1e626168ea57f1a914839c511" => :big_sur
    sha256 "6a4a2cb3d1ab17601808d8694f397b6c56b76a9371f0ebcf533b9b644bd84891" => :catalina
    sha256 "2ce44c5edafeb467da99af2d2bebce69e2cd2d5b4ff75cb17577a867aaf94aef" => :mojave
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nativefier --version")
  end
end

require "language/node"

class Fx < Formula
  desc "Command-line JSON processing tool"
  homepage "https://github.com/antonmedv/fx"
  url "https://registry.npmjs.org/fx/-/fx-17.0.0.tgz"
  sha256 "a9e1a5320de786293cce46a4e1fd052df88e31727b27d899c96d00dc73124b6f"

  bottle do
    cellar :any_skip_relocation
    sha256 "224d4b25fff41a710901feee0930785704fe0394fa669b8719e7a96716c04fdd" => :catalina
    sha256 "c1c90c65698f245ae562d5abdb604ecb1482c348371fc3e3910aaa05eb7adf5e" => :mojave
    sha256 "9a73f879388e824dc72cd2252e9fc5673c44f420276fcf4e1c38e11518597ca9" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "bar", shell_output("echo '{\"foo\": \"bar\"}' #{bin}/fx .foo")
  end
end

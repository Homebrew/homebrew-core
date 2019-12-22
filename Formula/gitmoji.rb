require "language/node"

class Gitmoji < Formula
  desc "Emoji guide for your commit messages"
  homepage "https://gitmoji.carloscuesta.me"
  url "https://registry.npmjs.org/gitmoji-cli/-/gitmoji-cli-3.0.1.tgz"
  sha256 "3dad45cb85a81a7f756d11897e6f7fe7089f92a7d44eb2de1acf75bf8c7166c6"

  bottle do
    cellar :any_skip_relocation
    sha256 "3bebe0ce99918a1dece7e8adee627162ec2000687939de06e301db6240757c1b" => :catalina
    sha256 "ee766ec2a08663d9589c7d03994e8403b65d83ed2e7b3dbb3a1bee09d27c738a" => :mojave
    sha256 "1fa38f10cd0412b9b376e428434baf2761656f3d1567d142783c7e7856435362" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match ":bug:", shell_output("#{bin}/gitmoji --search bug")
  end
end

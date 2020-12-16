require "language/node"

class Gitmoji < Formula
  desc "Emoji guide for your commit messages"
  homepage "https://gitmoji.carloscuesta.me"
  url "https://registry.npmjs.org/gitmoji-cli/-/gitmoji-cli-3.2.15.tgz"
  sha256 "256a970bc10356cd54854370ad26c1bb7b6edcb2eaae9df6b10a553df25b91db"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "34d409fb59c2af625f3325b1fae158a1047b502644dab7725d05df95e388431c" => :big_sur
    sha256 "ecff4beba14aef74d0221d632a9d5ba667c29d801236afb7a9718e7b40c734aa" => :catalina
    sha256 "edd8fab9ef80544a15c24e8572d42eb530375ff85f89b7f662d36c097b43dd3d" => :mojave
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

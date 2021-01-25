require "language/node"

class Hexo < Formula
  desc "Fast, simple & powerful blog framework"
  homepage "https://hexo.io/"
  url "https://registry.npmjs.org/hexo/-/hexo-5.3.0.tgz"
  sha256 "fe9f025d1f0d51e27a9a66cc691748c730f126b50bcc0c99bee239a582fd1ed8"
  license "MIT"
  head "https://github.com/hexojs/hexo.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "bc3cc137fef9e6bc0351f4438ae7a51c8ec9187fc2334c9ff5be74e7d118f9e6" => :big_sur
    sha256 "f5d1af98229cb54b69a8f256c45b20fecac6100c4663d38874c213cb7fe52936" => :arm64_big_sur
    sha256 "99db3ced545c108730dc565eacfbf91f39fd4235760c52ec55efc7731f7bc947" => :catalina
    sha256 "2a523c0293434b8b687eca111680d3044bbd1f6d4f4eaa0ca301ee2a22f0ba92" => :mojave
  end

  depends_on "node"

  def install
    mkdir_p libexec/"lib"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/hexo --help")
    assert_match "Usage: hexo <command>", output.strip

    output = shell_output("#{bin}/hexo init blog --no-install")
    assert_match "Cloning hexo-starter", output.strip
    assert_predicate testpath/"blog/_config.yml", :exist?
  end
end

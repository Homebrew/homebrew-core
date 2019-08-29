require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-8.3.1.tgz"
  sha256 "e16bef20218f9edfbe2a3d2045999d94ad583b027424938b1cab74f5fd22b0ab"

  bottle do
    cellar :any_skip_relocation
    sha256 "f00066abb450c2fc963179c89538446fc4c9e30ee4e469a376db130619197803" => :mojave
    sha256 "c9aa6e4ea7303ce49f4193953c1c8e83be999ce075e9313a1b0174fa33ee9c37" => :high_sierra
    sha256 "0efe407b2be77c2a94d565f1f1138c374d22db61cb15392324fc2ebef4cefcb8" => :sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ng", "new", "angular-homebrew-test", "--skip-install"
    assert_predicate testpath/"angular-homebrew-test/package.json", :exist?, "Project was not created"
  end
end

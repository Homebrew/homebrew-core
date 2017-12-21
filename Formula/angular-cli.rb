require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-1.6.2.tgz"
  sha256 "1b52888cc9b9ea8b1c2ee00b5af9f9502824cb5eb591471a21efec24286ecbcb"

  bottle do
    sha256 "05115cc8745360c4e45bac3c95089246ac07d2556efe4a57fa1395bb2f5a8120" => :high_sierra
    sha256 "abc95500a1ffab30f959b293141d878eb446aeae74fc3a4c4e2af97152d8a2ad" => :sierra
    sha256 "bbf6965cd93678310a103c3926df87355187abefed491d34cf5682418e63d79c" => :el_capitan
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ng", "new", "--skip-install", "angular-homebrew-test"
    assert_predicate testpath/"angular-homebrew-test/package.json", :exist?, "Project was not created"
  end
end

require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-1.6.0.tgz"
  sha256 "aafe0310fe778b32f96e9d64e4c838f84de45ab3de7b61c977d40b4f6f5e7b0f"

  bottle do
    sha256 "48d0ad1e8a1ab5de10ac9c82ae89759eaea701939202afdb63d04e4e9d41b3ae" => :high_sierra
    sha256 "8439b7c564d99db5232a7d502f85ba346df75820d370320ca967cc398994fc76" => :sierra
    sha256 "9de5c24635341d27cedb6770333a01bea5eab2cb2231d57a96cbc96bb78690cc" => :el_capitan
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

require "language/node"

class Alexjs < Formula
  desc "Catch insensitive, inconsiderate writing"
  homepage "https://alexjs.com"
  url "https://github.com/get-alex/alex/archive/9.0.1.tar.gz"
  sha256 "b4e70076c14c52ef275abadc6c32fccdd28db31153b26ce0731b926c5014865e"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "dd0ebbe18ac855859f8b69f721e326cfee8d8ee19ea4af51adf801eca3b0e300" => :catalina
    sha256 "3fc471e69908b83d73a42a20cdfd7467f79a921055aafdf03f6f4520138285b1" => :mojave
    sha256 "f3d30248e5219818a6b4fdadf2bbaf4e27949576f05b51322765189583042aaf" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.txt").write "garbageman"
    assert_match "garbage collector", shell_output("#{bin}/alex test.txt 2>&1", 1)
  end
end

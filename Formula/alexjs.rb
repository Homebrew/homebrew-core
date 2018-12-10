require "language/node"

class Alexjs < Formula
  desc "Catch insensitive, inconsiderate writing"
  homepage "https://alexjs.com"
  url "https://github.com/get-alex/alex/archive/7.0.0.tar.gz"
  sha256 "406ab546c773eccb40a2ef756019894dd00635de7f05feb76d48f0850c6644a6"

  bottle do
    cellar :any_skip_relocation
    sha256 "4448a72318e45cbd3e47a6763555439417f556a45d19a57692ca6c891c3fa1b8" => :mojave
    sha256 "c7d03a223d9cae6603cbeb2dd46070cbb79c2e1a012896d9e69e313e1472fcda" => :high_sierra
    sha256 "0636f6ec0a9788daad20bf60b341a25ca26f367f8a6e72ea05998031a7b95701" => :sierra
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

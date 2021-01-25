require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-1.2.7.tgz"
  sha256 "590679c0053b5fff1cf714b47abbf6fb712e916ee6a3a0c1210840551716ac18"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "beb4dd0e093ad7753855705c734dae9ba522d9e7414b38ac240352d6aab3bbac" => :big_sur
    sha256 "5050e98f7a5a9715a491030f6a552beb6a90a222a1fee74d330177039f85ac90" => :arm64_big_sur
    sha256 "62b9478edcbf45327e3d4bca454c4c34a505aa9f23a450bacead225c9a227b79" => :catalina
    sha256 "4ba7f9cf413ab50cde3050f96262ec740b186c684e7d5a8f434adecfa8cda8f8" => :mojave
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal "<p>hello <em>world</em></p>", pipe_output("#{bin}/marked", "hello *world*").strip
  end
end

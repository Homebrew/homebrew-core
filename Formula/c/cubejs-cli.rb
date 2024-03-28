require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.35.5.tgz"
  sha256 "20c446bb91da7e1c87dbed5a36ecbd67485434f8de9ea03d4db5fd9edb8726e7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3a2f67ec6d7fb4fed3d347090e5a5a3384278fa11bfd40a46a90802aa7b0f0c4"
    sha256 cellar: :any,                 arm64_ventura:  "3a2f67ec6d7fb4fed3d347090e5a5a3384278fa11bfd40a46a90802aa7b0f0c4"
    sha256 cellar: :any,                 arm64_monterey: "3a2f67ec6d7fb4fed3d347090e5a5a3384278fa11bfd40a46a90802aa7b0f0c4"
    sha256 cellar: :any,                 sonoma:         "c794178016d9d4cbcd9f3cad84bcf218aa2289db88f7d5fcb3980d462dc8fa33"
    sha256 cellar: :any,                 ventura:        "c794178016d9d4cbcd9f3cad84bcf218aa2289db88f7d5fcb3980d462dc8fa33"
    sha256 cellar: :any,                 monterey:       "c794178016d9d4cbcd9f3cad84bcf218aa2289db88f7d5fcb3980d462dc8fa33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80b60dc86b7ed8645af42ef71f904685a6496952e73c8e86ea3c4404e407aece"
  end

  depends_on "node"
  uses_from_macos "zlib"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/model/cubes/orders.yml", :exist?
  end
end

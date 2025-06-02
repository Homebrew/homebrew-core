class NodeSass < Formula
  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.89.1.tgz"
  sha256 "ed8339c7ba1170192eb8e2c66b0fa2226e17a36fbe7f240131bb84ec2ab332c8"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "29421a428852e492e65be40fcd15ca7804855cdb02daf660e19a74712b0e8880"
    sha256                               arm64_sonoma:  "22e9b0aafabc3851805528a34647af3436cc946a563253a723ae0e37ab4b8169"
    sha256                               arm64_ventura: "0408d2ec7c99d522504c03a3fb05620d84df36c5da9c906305a76066bb8af228"
    sha256                               sonoma:        "93e6d16c35f9c7c388161c783149249e43d212d29e7a3644f1f3701314c205cb"
    sha256                               ventura:       "9bc1d947b2ba6d47358777cdc7dad96213d1f3d49dda78948bf5f55b44bde666"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf718c2d739c78d5f0c7b2445815d6c8270ce4eaed1da8fb6c741871e38c7be9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab9011f8b0bc9cc9433c1ea5c93bc40b15cb853fa8cd68ab327579912288e8e4"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.scss").write <<~EOS
      div {
        img {
          border: 0px;
        }
      }
    EOS

    assert_equal "div img{border:0px}",
    shell_output("#{bin}/sass --style=compressed test.scss").strip
  end
end

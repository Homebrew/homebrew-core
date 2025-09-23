class NodeSass < Formula
  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.93.1.tgz"
  sha256 "75bda5f61b83267b5b49f33207a8ae9ba08be567fcb91e79ec4404457d225951"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "a4aab4482dcd1f4a7a2af7768842c2615cb6be59857e3ffd435dd6041207ffa6"
    sha256                               arm64_sequoia: "cd79b159b801fd34d7855d31689c70cebe9144b52fcbc5b6f180cafed329e3f4"
    sha256                               arm64_sonoma:  "65049fe535aeda552892f0fc5bdb7a894f0dc3d093aa9cc7de95dc0007720bfb"
    sha256                               sonoma:        "054e14a455d652acca44face1a477ea6de0d1453feb6cf2ad22a4aac35c0722e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e6fe6fc5eab6e3e5612104e2fd2629d93dfed7831ec2bf094a4971acb07cfe1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04d7bfcf273ab59572f1db279e685433259ba0ff7596580c63938a38f82c3f4a"
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

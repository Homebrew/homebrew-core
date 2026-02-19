class NodeSass < Formula
  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.97.3.tgz"
  sha256 "cfe3175ed6c5f2b2c0bafc893b30930f67ac8a3105ff516d253c00ad18fa89ea"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "15a879e3d1f1ace6178f43fffcfd7029ebe4f22f4c488344f26886c9c69897f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15a879e3d1f1ace6178f43fffcfd7029ebe4f22f4c488344f26886c9c69897f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15a879e3d1f1ace6178f43fffcfd7029ebe4f22f4c488344f26886c9c69897f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d4e56b85d3e3450eda92b7d1ef2877e85bf21137200b27033dbd437275c41ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0549bf9a5b98b7359028e60ca3aa9951d945a30d6629cfcbfe82cd3ea4700d4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e7b9364654d6b7b856c8e0d7359107a4c13ebdbedbd792e403df29944fe6509"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
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

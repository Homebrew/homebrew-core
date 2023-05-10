require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-12.0.0.tgz"
  sha256 "335b1943a8fce510e0c45219084cf55591c478c8d27003ed2beab974ed9cd7fb"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_ventura:  "8815bc12f7ff6ef88ad12c9ac952772b1dd3933e0a8279df4a5b2dedb98edae6"
    sha256                               arm64_monterey: "bddbdbc00041e64cf7d3d23f043f059ccd9e78bb97519f9ac0886be4bc26d527"
    sha256                               arm64_big_sur:  "450a1cdd7251c4048884a4d078d4a51cd8d0a51e997e7709b166c15408a76979"
    sha256                               ventura:        "1eb0f4b39f2a0d10f126c194b03e07436edfd916bace17b9326c76cbd2648cfe"
    sha256                               monterey:       "7987c114bd6ceea3315e1ea123022384449b71304af4fc39cb38b0bee59f7213"
    sha256                               big_sur:        "cfb3a25d865e5cb1121e9b12f1d7959acd7213ba5fefcb43257d57d745b4e45f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea105a59a40721a65e9e34a5739d7bd8cf3bde8431ebd0464d63adde8d047a28"
  end

  depends_on "node"

  uses_from_macos "expect" => :test

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.exp").write <<~EOS
      spawn #{bin}/firebase login:ci --no-localhost
      expect "Paste"
    EOS
    assert_match "authorization code", shell_output("expect -f test.exp")
  end
end

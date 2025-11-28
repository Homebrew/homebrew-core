class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://github.com/mongodb-js/mongosh"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-2.5.10.tgz"
  sha256 "ae1a9be2ab8e8c5ab37e436129799577943e160bac58bc893510484e4ab330b8"
  license "Apache-2.0"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256                               arm64_tahoe:   "65137675136270a148046a30df8f6653c0fa1673d297125015fe046764119c20"
    sha256                               arm64_sequoia: "e4b3df3018e25b2df4fff13617c490d425f921235406941058a22d9d9bb20e58"
    sha256                               arm64_sonoma:  "5b851ba4417c3836e903dd93d044e6e10e3514fda11018d1b4eed6e03d656bcc"
    sha256                               sonoma:        "376e097936e91b2f66415291025f595420a05595166e2217cda6c0b63585db4f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f219496da33bf5c25772cdd22359f6cf2c0fd8675714ab1bce2236b85f30f3a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dcd1abda54c4bb7272da9330fbf1b8d5cb85b0a2aff6858406458a2c98898da9"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "ECONNREFUSED 0.0.0.0:1", shell_output("#{bin}/mongosh \"mongodb://0.0.0.0:1\" 2>&1", 1)
    assert_match "#ok#", shell_output("#{bin}/mongosh --nodb --eval \"print('#ok#')\"")
    assert_match "all tests passed", shell_output("#{bin}/mongosh --smokeTests 2>&1")
  end
end

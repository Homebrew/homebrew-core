require "language/node"

class Alexjs < Formula
  desc "Catch insensitive, inconsiderate writing"
  homepage "https://alexjs.com"
  url "https://github.com/get-alex/alex/archive/9.1.0.tar.gz"
  sha256 "1e9acfabd7c7078278007bcfeccb3827ffec92a5c226ab1a387077997ee3dad4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1869fa035c9ce8179295d3cd697c8abfbc72a5fefc81d12ce0c047bf4db64eae"
    sha256 cellar: :any_skip_relocation, big_sur:       "1102acddac4146addf4d4b59ac66bf5d5d57b2badabfe9038c286ab5660c63f6"
    sha256 cellar: :any_skip_relocation, catalina:      "e37814ad3315475e5484cc5c334089213a023ea443ccb2207702b8667f3e1a0e"
    sha256 cellar: :any_skip_relocation, mojave:        "7c2d9fedf79264bd59e73b7f062512e03afdd1e6a66152c233996471636549f1"
    sha256 cellar: :any_skip_relocation, high_sierra:   "462578faccc1fd6ba5df072a50c90c28522067e6cbba84a3b6a6dfa29c7a2eaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f68677cdd5368c5da400dd06c99652dd90a30a0973d0cb4fc80fdadc994a5ea7"
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

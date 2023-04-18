require "language/node"

class GraphqlCli < Formula
  desc "Command-line tool for common GraphQL development workflows"
  homepage "https://github.com/Urigo/graphql-cli"
  url "https://registry.npmjs.org/graphql-cli/-/graphql-cli-4.1.0.tgz"
  sha256 "c52d62ac108d4a3f711dbead0939bd02e3e2d0c82f8480fd76fc28f285602f5c"
  license "MIT"

  # The Npm page is nearly 2 MB compressed (due to there being thousands
  # of pre-release versions of the package) and livecheck can time out, so we
  # check the Git tags in this instance.
  livecheck do
    url :homepage
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1828f727e53a0d4605a62affb657d94d86c4e9edb530cf9db16c9d61b0946519"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f0032a97995c66d8f090765b11c3fc85af23a7ca389cce6f2e183508721e4039"
    sha256                               arm64_big_sur:  "2da205bbd5c76588be334a84b52dacfac9062045d605ed3f8298b7cb7b9b84a7"
    sha256 cellar: :any_skip_relocation, ventura:        "c0603e5871fee5982513c8f28020e94bb85482f9157db3be8e7b2df987b7d551"
    sha256 cellar: :any_skip_relocation, monterey:       "81cb7b69b2c0f61b042cd95eb434bf59f594815bd85b686e6336db6aa27ff725"
    sha256                               big_sur:        "02d60908557d5dedf63fffe66a51f5829807abd910b5460a2ae44d7b8d208142"
    sha256                               catalina:       "5060d007d13a695709ff9afaa16a1492d8645e17ab78ec2b14650e0c7a305e55"
    sha256                               mojave:         "212bf2d20997a930838775736ca468dc25cbd3c3978c0189f8a435873a029286"
    sha256                               high_sierra:    "d8f266f129027b1fe731c12264f7b8679c271ecdb6418cef72dba0a730e99771"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48fc095743bddaa241e8ec367b80d06f4b742c6f5e3327c2d2f07ed941514adb"
  end

  depends_on "node"

  uses_from_macos "expect" => :test

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Avoid references to Homebrew shims
    rm_f "#{libexec}/lib/node_modules/graphql-cli/node_modules/websocket/builderror.log"
  end

  test do
    (testpath/"test.exp").write <<~EOS
      #!/usr/bin/env expect -f
      set timeout -1
      spawn #{bin}/graphql init

      expect -exact "Select the best option for you"
      send -- "1\r"

      expect -exact "? What is the name of the project?"
      send -- "brew\r"

      expect -exact "? Choose a template to bootstrap"
      send -- "1\r"

      expect eof
    EOS

    system "expect", "-f", "test.exp"

    assert_predicate testpath/"brew", :exist?
    assert_match "Graphback runtime template with Apollo Server and PostgreSQL",
                 File.read(testpath/"brew/package.json")
  end
end

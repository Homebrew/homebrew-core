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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "5b3b93d8d2e8b80bd3ebc5918dcde22171f00e81042c287c722ca10abda75034"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c672ef9a3deeb3eb60a1d1c38f675d28a2034b681586336d3c4b027447cd9822"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c672ef9a3deeb3eb60a1d1c38f675d28a2034b681586336d3c4b027447cd9822"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c672ef9a3deeb3eb60a1d1c38f675d28a2034b681586336d3c4b027447cd9822"
    sha256 cellar: :any_skip_relocation, sonoma:         "0f017f0dd3476f251ad911d86b10eb1c886b1dc4cce5e3e90fe9086c0afae841"
    sha256 cellar: :any_skip_relocation, ventura:        "0f017f0dd3476f251ad911d86b10eb1c886b1dc4cce5e3e90fe9086c0afae841"
    sha256 cellar: :any_skip_relocation, monterey:       "0f017f0dd3476f251ad911d86b10eb1c886b1dc4cce5e3e90fe9086c0afae841"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4616cf8f3ee26c6edf63ddd6573e1ef1b59a5d03c5a068d8e19f6a0f69ce4299"
  end

  depends_on "node"

  uses_from_macos "expect" => :test

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
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

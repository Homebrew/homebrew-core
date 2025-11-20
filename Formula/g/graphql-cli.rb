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

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "9acfbbbc98a9212677f8cda3b773d20958ddb1cd5503d2c9894e531e44861832"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    require "expect"
    require "open3"

    Open3.popen2(bin/"graphql", "init") do |stdin, stdout, wait_thread|
      stdout.expect "Select the best option for you"
      stdin.write "1\n"
      stdout.expect "? What is the name of the project?"
      stdin.write "brew\n"
      stdout.expect "? Choose a template to bootstrap"
      stdin.write "1\n"
      wait_thread.join
    end

    assert_path_exists testpath/"brew"
    assert_match "Graphback runtime template with Apollo Server and PostgreSQL", (testpath/"brew/package.json").read
  end
end

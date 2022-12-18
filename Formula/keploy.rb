class Keploy < Formula
  desc "Testing Toolkit creates test-cases and data mocks from API calls, DB queries"
  homepage "https://keploy.io"
  url "https://github.com/keploy/keploy/archive/refs/tags/v0.7.6.tar.gz"
  sha256 "69b586f6a2ac8e28966d534e93108d493ca21e88454bf1f1e53a09295dc14eb3"
  license "Apache-2.0"

  depends_on "gatsby-cli" => :build
  depends_on "go" => :build
  depends_on "node"

  resource("ui") do
    url "https://github.com/keploy/ui/archive/refs/tags/0.1.0.tar.gz"
    sha256 "d12cdad7fa1c77b8bd755030e9479007e9fcb476fecd0fa6938f076f6633028e"
  end

  def install
    resource("ui").stage do
      system "npm", "install", "--legacy-peer-deps", *Language::Node.local_npm_install_args
      system "gatsby", "build"
      buildpath.install "./public"
    end
    cp_r "public", "web", remove_destination: true
    system "go", "build", *std_go_args, "./cmd/server"
  end
  test do
    port = free_port
    pid = fork do
      assert_match("👍 connect to http://localhost:#{port}/ for GraphQL playground",
                   shell_output("export PORT=#{port} && #{bin}/keploy"))
    end
    sleep 6
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end

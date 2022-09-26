require "language/node"
require "fileutils"
class Keploy < Formula
  desc "Unit Testing Toolkit that creates test-cases and data mocks from API calls"
  homepage "https://keploy.io"
  url "https://github.com/keploy/keploy/archive/refs/tags/v0.5.5.tar.gz"
  sha256 "37a4a27d30ed831c8fd4f60609df4c6b3ce1633fd468696e8098a35a16140377"
  license "Apache-2.0"

  depends_on "gatsby-cli" => :build
  depends_on "go" => :build
  depends_on "node@14" => :build

  def install
    system "git", "clone", "https://github.com/keploy/ui.git"
    Dir.chdir("ui") do
      system "npm", "install", *Language::Node.local_npm_install_args
      system "gatsby", "build"
    end  
    cp_r "ui/public", "web"
    rm_rf "ui"
    Dir.chdir("cmd/server") do
      system "go", "build", "-o", "keploy"   
      bin.install "keploy"
    end      
  end
  test do
    pid= fork do    
      assert_match("👍 connect to http://localhost:8081/ for GraphQL playground", shell_output("#{bin}/keploy"))
    end
    sleep 6
  ensure
    Process.kill('TERM',pid)
    Process.wait(pid)
  end
end

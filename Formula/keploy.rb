class Keploy < Formula
  desc "Testing Toolkit creates test-cases and data mocks from API calls, DB queries"
  homepage "https://keploy.io"
  url "https://github.com/keploy/keploy/archive/refs/tags/v0.7.21.tar.gz"
  sha256 "acaf26011a421a1074f644bc10eff18f04e232d41420d69413d8c303aee18adb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e0c3cef00a7b742848d0bc0a5feaef9178e2869d4a927e3e6063c42fa91683e8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c8f41726c7665270edc7fed79532eebffca3b5fba2067692707b0144c06d42d6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f72acec4fe5a99038bb39e7dba58642c95b7c9a591b20aba83a134a26a8dc466"
    sha256 cellar: :any_skip_relocation, ventura:        "cf9615bfacf2ac385d5c8927c2d3a93d8dafad4da670cca43694133a30314eaa"
    sha256 cellar: :any_skip_relocation, monterey:       "0ad3295116990d8b573cfcbdd9a40bfd52ea6da238bc85a133eea4291e9a7cd1"
    sha256 cellar: :any_skip_relocation, big_sur:        "bda37f0273d89131c3dd8eea5fd16b08b433f6dae60916bd7d17423f522cd075"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "984ac42a0deab3709a1d9c5beac02f3ca3baf02cede7c8c6b27a318cef7e9806"
  end

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
    require "pty"

    port = free_port
    env = { "PORT" => port.to_s }
    executable = bin/"keploy"

    output = ""
    PTY.spawn(env, executable) do |r, _w, pid|
      sleep 2
      Process.kill("TERM", pid)
      begin
        r.each_line { |line| output += line }
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    end
    assert_match("keploy started at port #{port}", output)
  end
end

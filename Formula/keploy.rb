class Keploy < Formula
  desc "Testing Toolkit creates test-cases and data mocks from API calls, DB queries"
  homepage "https://keploy.io"
  url "https://github.com/keploy/keploy/archive/refs/tags/v0.7.14.tar.gz"
  sha256 "eb131601f953cb8f356cc3d8fdbb0b7bb39ff153589d0289455869961b4391da"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b9b153d1d6b044211cb762fe76f61acf95b864a38801b415e7522fd552671170"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d7f9c129ac41deb2a8b14d5ea46e0236ac552baf4caf1b98b76a8f6981c1ba66"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a2bbf9305bb622eb10f89a2b2f4e51344bd527867e507d9a719f8cb904f76ac5"
    sha256 cellar: :any_skip_relocation, ventura:        "1347e0f5eab06d5f9d9f70c46a8af7e4b4cff5eabd2919403887854b7e4a510d"
    sha256 cellar: :any_skip_relocation, monterey:       "6bd23d6aeecdb9b1804496803c6851966a18d46d139e655c853a90cb10c07a3d"
    sha256 cellar: :any_skip_relocation, big_sur:        "a12a36ca88345250c0ae79c55ff2202d2f6490b47bdfc442001282588b9d690a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a4c3300da056a2d05e613364477ecf4568e8aa47beec95afc231259734b8e17"
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

class Envconsul < Formula
  desc "Launch process with environment variables from Consul and Vault"
  homepage "https://github.com/hashicorp/envconsul"
  url "https://github.com/hashicorp/envconsul.git",
      tag:      "v0.13.2",
      revision: "dd416cebc7373914548a2df69af0a97c9432ef91"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "0836a955bab02d876af68083fa6006fefcb94edfdca86b96a753c28641df8ed7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ee40f42e33996864a721efb979f0a01b28e5c42f133469f89ff423c428d3d557"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "787d365fe17ad5b3de36bcf0ab9ff02a01e5ce5ac31c859ece7efd868c27c206"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "787d365fe17ad5b3de36bcf0ab9ff02a01e5ce5ac31c859ece7efd868c27c206"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "787d365fe17ad5b3de36bcf0ab9ff02a01e5ce5ac31c859ece7efd868c27c206"
    sha256 cellar: :any_skip_relocation, sonoma:         "f6f0ae96a6931d0e35481c1635aa189fb7b2a4ecb70b0362ba01a55ec89ce324"
    sha256 cellar: :any_skip_relocation, ventura:        "76477948a712b91bc3a69e51ea06476e3ea0d6fb6638f09c482ab8cf54e04786"
    sha256 cellar: :any_skip_relocation, monterey:       "76477948a712b91bc3a69e51ea06476e3ea0d6fb6638f09c482ab8cf54e04786"
    sha256 cellar: :any_skip_relocation, big_sur:        "76477948a712b91bc3a69e51ea06476e3ea0d6fb6638f09c482ab8cf54e04786"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c9a3eef22e1fb333f855e770754d15df7c5e996ed7a387d465f1daf0bfb2b2d"
  end

  deprecate! date: "2024-02-05", because: "depends on soon to be deprecated consul"

  depends_on "go" => :build
  depends_on "consul" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  def port_open?(ip_address, port, seconds = 1)
    Timeout.timeout(seconds) do
      TCPSocket.new(ip_address, port).close
    end
    true
  rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH, Timeout::Error
    false
  end

  test do
    require "socket"
    require "timeout"

    consul_default_port = 8500
    localhost_ip = "127.0.0.1".freeze

    begin
      if port_open?(localhost_ip, consul_default_port)
        puts "Consul already running"
      else
        fork do
          exec "consul agent -dev -bind 127.0.0.1"
          puts "Consul started"
        end
        sleep 5
      end
      system "consul", "kv", "put", "homebrew-recipe-test/working", "1"
      output = shell_output("#{bin}/envconsul " \
                            "-upcase -prefix homebrew-recipe-test env")
      assert_match "WORKING=1", output
    ensure
      system "consul", "leave"
    end
  end
end

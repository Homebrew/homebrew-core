class Envconsul < Formula
  desc "Launch process with environment variables from Consul and Vault"
  homepage "https://github.com/hashicorp/envconsul"
  url "https://github.com/hashicorp/envconsul.git",
    :tag      => "v0.9.3",
    :revision => "1729aafafcc96929db40400eaf10bc0d70840480"

  bottle do
    cellar :any_skip_relocation
    sha256 "4c6124368ea055ecca7e5b75484ed0da40b3de0c86c43e9188c0b00447e9b52b" => :catalina
    sha256 "a0488492fac09bc1f89a224264602505e3fa7fda8747614ba8a40df5566cd77a" => :mojave
    sha256 "418b4cc14d268c77074fb118cafe2165a1d4eab9b74489647328328b97d5327d" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "consul" => :test

  def install
    system "go", "build", "-ldflags", "-s -w", *std_go_args
    prefix.install_metafiles
  end

  test do
    port = free_port
    begin
      fork do
        exec "consul agent -dev -bind 127.0.0.1 -http-port #{port}"
        puts "consul started"
      end
      sleep 5

      system "consul", "kv", "put", "-http-addr", "127.0.0.1:#{port}", "homebrew-recipe-test/working", "1"
      output = shell_output("#{bin}/envconsul -consul-addr=127.0.0.1:#{port} " \
                            "-upcase -prefix homebrew-recipe-test env")
      assert_match "WORKING=1", output
    ensure
      system "consul", "leave", "-http-addr", "127.0.0.1:#{port}"
    end
  end
end

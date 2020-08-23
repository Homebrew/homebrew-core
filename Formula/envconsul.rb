class Envconsul < Formula
  desc "Launch process with environment variables from Consul and Vault"
  homepage "https://github.com/hashicorp/envconsul"
  url "https://github.com/hashicorp/envconsul.git",
    tag:      "v0.10.0",
    revision: "1835ce900c68f8bf37e384fb65d8e4763e78ab5a"
  license "MPL-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "0c24de84c15beae1d7dae04403be0bcd7732372be8bc75adb1fe19d6278e2107" => :catalina
    sha256 "4f5a2fbc1b7010c85610a4bf51daacc8f7acb1e787b1577f1b3d55cf4b95692d" => :mojave
    sha256 "2cefa866ee17b44d57e02f5a006d5a933ca53d19286cd438c3de33109a8f0219" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "consul" => :test

  def install
    system "go", "build", "-ldflags", "-s -w", *std_go_args
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

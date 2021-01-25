class Envconsul < Formula
  desc "Launch process with environment variables from Consul and Vault"
  homepage "https://github.com/hashicorp/envconsul"
  url "https://github.com/hashicorp/envconsul.git",
      tag:      "v0.11.0",
      revision: "c3eeb0d39addb0ceb81cca91d4202cfc667fddd7"
  license "MPL-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "e377dbb6afa6b25649a4b4bbfc382a9a6b5a44f5f91ce7d41bbb154be102d746" => :big_sur
    sha256 "179a94430ca555ec57a15d21e6b470616ed741a7ae8d636e4e3e72ea1b8f9b7b" => :catalina
    sha256 "2bfcec63fd169c27ffc12ee5acea1da314de51a5be0a6185ef111655c3b79d9c" => :mojave
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

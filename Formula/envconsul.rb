class Envconsul < Formula
  desc "Launch process with environment variables from Consul and Vault"
  homepage "https://github.com/hashicorp/envconsul"
  url "https://github.com/hashicorp/envconsul.git",
    :tag      => "v0.9.3",
    :revision => "1729aafafcc96929db40400eaf10bc0d70840480"
  license "MPL-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "54aca2b7ad236dfadfe9b2c8db6df755ba16de8c458f74dd71e994f6aab976ca" => :catalina
    sha256 "a27ce0e1775134b40891dc746ff36c2f046a96e3ab57a6aed20f805ba7d88db2" => :mojave
    sha256 "f92ba9326c7ac451e91b35bc692ffb461691ade89df336afb1ef1931d4de644f" => :high_sierra
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

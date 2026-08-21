class Anyquery < Formula
  desc "Query anything with SQL"
  homepage "https://anyquery.dev"
  url "https://github.com/julien040/anyquery/archive/refs/tags/0.5.0.tar.gz"
  sha256 "9ffd6d41e41f51e5e648442c9c6a1621c6a64183756bb3ef1d4d9ba659c81fd4"
  license "AGPL-3.0-only"
  head "https://github.com/julien040/anyquery.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7fce2013172c302466960dd0e00a1771a847f61b332d94c1f6bf7ba2f95e42f2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cff58e5c8b25397464c13cf853375450b83d088433c0983cbd59ce34c8aa59c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6be0926405ef1ae54d05a9e3535c32d244ff84b4c264dbb5b27f8a65fb48bb32"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3a363c0339df4d31a761e2755407e9a562bb953c807256ba916e580994bc3e8"
    sha256 cellar: :any,                 arm64_linux:   "61694bc8ce079a0789d0da0e69fb787ec4b047f19fae4d6c9b7e27aa16c6ae9f"
    sha256 cellar: :any,                 x86_64_linux:  "0d6f1036bf6d5a994c7723b407497e24a606c72497aae3b703a825c33aa4c305"
  end

  depends_on "go" => :build
  depends_on "mysql-client" => :test

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    tags = %w[
      vtable
      fts5
      sqlite_json
      sqlite_math_functions
    ]
    system "go", "build", *std_go_args(tags:)

    generate_completions_from_executable(bin/"anyquery", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/anyquery -q \"SELECT * FROM non_existing_table\"")
    assert_match "no such table: non_existing_table", output

    port = free_port.to_s
    pid = spawn bin/"anyquery", "server", "--port", port
    begin
      sleep 5
      output = shell_output("#{Formula["mysql-client"].bin}/mysql -h 127.0.0.1 -P #{port} -e 'show tables;' main")
      assert_match "information_schema.COLLATIONS", output
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end

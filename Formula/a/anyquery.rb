class Anyquery < Formula
  desc "Query anything with SQL"
  homepage "https://anyquery.dev"
  url "https://github.com/julien040/anyquery/archive/refs/tags/0.5.1.tar.gz"
  sha256 "cc9972f442e6df9dbf4274c641dd470ef30058dbbe78c4525c5190eab1ec4f9a"
  license "AGPL-3.0-only"
  head "https://github.com/julien040/anyquery.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "eac4011032c61e1b1e2a63018e432cc363be06ecfa0d397a5f94145e0aa01af7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "81fca37f7fc7455f37b658b0b71851abe465e18a7629e68c4c02495e47fb4bd4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "34d3cb7608d5abbf79d41d91a55796afe09be16a029a37aa515f76e75e1ca469"
    sha256 cellar: :any,                 arm64_linux:       "1714d4a06fd66e2258f835abde5b778fb7f20f865cd83176bdfa8daf25e63b43"
    sha256 cellar: :any,                 x86_64_linux:      "5ffba65a9f9f6d10464a2e566bc355b086714dc9cc7d221b3a52efd833900ab5"
  end

  depends_on "go" => :build
  depends_on "mysql-client" => :test

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    # TODO: Remove http2legacy once x/net >= 0.55.0: https://github.com/grpc/grpc-go/issues/9206
    tags = %w[
      vtable
      fts5
      sqlite_json
      sqlite_math_functions
      http2legacy
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
      output = shell_output("#{formula_opt_bin("mysql-client")}/mysql -h 127.0.0.1 -P #{port} -e 'show tables;' main")
      assert_match "information_schema.COLLATIONS", output
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end

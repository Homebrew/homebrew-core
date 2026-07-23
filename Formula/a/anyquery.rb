class Anyquery < Formula
  desc "Query anything with SQL"
  homepage "https://anyquery.dev"
  url "https://github.com/julien040/anyquery/archive/refs/tags/0.4.6.tar.gz"
  sha256 "791b4be32ae031ad6321116009e7ddc13464273f09a7afbea0501e0d33df58f6"
  license "AGPL-3.0-only"
  head "https://github.com/julien040/anyquery.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a648d9e0106b1e8776e8a44b462f3ffa06a11e3bf8100fc24b178dc34a05c03c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3fe0aef738aeec5c88dbdcc54c36cbf86df7483e38ff6855c86df1d50b8cf109"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eaab7fd289b1b6872175dca16894ae19f305d019645c11e86ce7ede86c069f47"
    sha256 cellar: :any_skip_relocation, sonoma:        "f314427b14b68046d1e09e4946952176bf931b916f4d4f55713c1f5dff69c39a"
    sha256 cellar: :any,                 arm64_linux:   "25ce3b87b297593cda9ca39c1bbaef43f1973f707f329ba85a768ca69082abd9"
    sha256 cellar: :any,                 x86_64_linux:  "c2de4decfc85f9436dd5b64f82bc8e68edbb6050159d4ef970969a3b9acbbc87"
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
    system "go", "build", *std_go_args(ldflags: "-s -w", tags:)

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

class Anyquery < Formula
  desc "Query anything with SQL"
  homepage "https://anyquery.dev"
  url "https://github.com/julien040/anyquery/archive/refs/tags/0.4.4.tar.gz"
  sha256 "f174106c27af67e2d378713666d90b713edc52950be677312e2c282db54b279c"
  license "AGPL-3.0-only"
  head "https://github.com/julien040/anyquery.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "274f7b4bf4f7f4107c438522bae53022e84497f2960410468b01e90496ba4734"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc1de3c724b1aa8b57c735e50bc6156ebd87b75bf70b1b2e232ba375e41b5ac8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "471f683b20106cf05750ff9a630127b9d9048ad82cd78b157968c335c137fe6f"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb0c2cc8c39e8e4d4719dee0e0448abae3c95a76a754f510d2edcbcd64f3ed09"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4a33f8dbe6443662ad426bc8d32a683ea07fea23a7ef259e45c5c029f904069"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe11155b9ff95e6974a11c963eba2ccf3ee387bfb8357fe51d5793b3542223be"
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

class Anyquery < Formula
  desc "Query anything with SQL"
  homepage "https://anyquery.dev"
  url "https://github.com/julien040/anyquery/archive/refs/tags/0.4.4.tar.gz"
  sha256 "f174106c27af67e2d378713666d90b713edc52950be677312e2c282db54b279c"
  license "AGPL-3.0-only"
  head "https://github.com/julien040/anyquery.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8e606702ce9cb04a446b1180ec22c133b07e5c549f360590094aa91291310212"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48135a4e7ac901b87c0a115352e67bd6c5170ab2ceae5525e41593be478b878b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6408120e49f7f1126fda43abb4ff1a5446a5be557beefbc5d3954db985b555c"
    sha256 cellar: :any_skip_relocation, sonoma:        "09a95872694c7195c6dd197ac981f2799e2e20804b286ab9739d417e75bde95d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "59c435670a58f69be3447cabd2e479b95e4d008ac7f6635ef53069dc4848fef2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a72dd22e82c070ba3d3fce162b4af27ee37b0aa09d70418e8f02a821168a2a0"
  end

  depends_on "go" => :build

  def install
    tags = %w[
      vtable
      fts5
      sqlite_json
      sqlite_math_functions
    ]
    system "go", "build", *std_go_args(ldflags: "-s -w", tags:)
    generate_completions_from_executable(bin/"anyquery", "completion")
  end

  test do
    assert_match "no such table: non_existing_table",
                 shell_output("#{bin}/anyquery -q \"SELECT * FROM non_existing_table\"")
    # test server
    pid = fork do
      system bin/"anyquery", "server"
    end
    sleep 20
  ensure
    Process.kill("TERM", pid)
  end
end

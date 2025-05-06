class Anyquery < Formula
  desc "Query anything with SQL"
  homepage "https://anyquery.dev"
  url "https://github.com/julien040/anyquery/archive/refs/tags/0.4.1.tar.gz"
  sha256 "31b3fa6506aadabda9b53c977964d7548602a7311acacb6f407f09a78d6005ca"
  license "AGPL-3.0-only"
  head "https://github.com/julien040/anyquery.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b363cd009398d2392c99117f66858a2e4c8a4500d45cfe3625ead058cb09bea9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c9394f9d0e66ed4b3ad67b3ca08a632c41233d4b4fa04131c38697c4be76214"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "44bbaf4e254068d5e88da2bfefff78fd29e45fa7311a51282bee8ab42ebaa03b"
    sha256 cellar: :any_skip_relocation, sonoma:        "627ac11a9ad4c6c243e4a6306ff5f53b6f1d37355c23a4fae3e7fcccf1ea3636"
    sha256 cellar: :any_skip_relocation, ventura:       "83bccaa1b8a214c6e371bef27b982757f21d9c1bad4cf59bf010b80c74749ed8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f1c6b705f45ce8dee3bd1a1c0dc01b22768a462e71ab3f4d8539471c8772715e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1bc174f34b9a509d9876d2d4902b2f5ea3ca5643b29af184f73fdcb5bd280a9a"
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

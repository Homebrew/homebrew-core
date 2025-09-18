class Anyquery < Formula
  desc "Query anything with SQL"
  homepage "https://anyquery.dev"
  url "https://github.com/julien040/anyquery/archive/refs/tags/0.4.3.tar.gz"
  sha256 "515541e21737979291d1a7c026db352ffc202c9e1887ec5ba4fb1fab512d9ee9"
  license "AGPL-3.0-only"
  head "https://github.com/julien040/anyquery.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3e9bcdfd4695f8793f064b6ac6f53af0247e13be4c1b164c65f491f1052bbc9e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b138324377b2466c541d1e76f1738238c7d9d819358bb8020ee0254c3b96299c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d783682922387e180225c689bde454837dab189587143cfc0f7256888a481d7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "abcc030d957a0ccd633c9e8f0391787c048c322d0cd85debbadf30129e320946"
    sha256 cellar: :any_skip_relocation, sonoma:        "1bb0a768821d237e07b87e738679be390a25fc4189a513ee968b3417a0712a28"
    sha256 cellar: :any_skip_relocation, ventura:       "b9bf19bc46f438bcce4194028e8af6750f9b39f9fcd0955b4e48a2a673dc3d02"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "70c92b2eb51884a6a952b50182e73fa570b8e4d62cc535ac437797870eebf9fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1af1441b6edf51f29e315ed838bd32848e9ddb1720a4e6c6d6e2214ab1a7d6c0"
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

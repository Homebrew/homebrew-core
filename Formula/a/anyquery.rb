class Anyquery < Formula
  desc "Query anything with SQL"
  homepage "https://anyquery.dev"
  url "https://github.com/julien040/anyquery/archive/refs/tags/0.4.2.tar.gz"
  sha256 "fd7a249965fa4cb014629772fa4d9c79acb823c89f73fb68c9c1361a08cd11c6"
  license "AGPL-3.0-only"
  head "https://github.com/julien040/anyquery.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "633ae2407073601f460b229f3beb084266437459fe714f69bd59e131d64e7f13"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b17f457620eb7440cc85dc95fa8459f99b2c4f12fbb6da748b8877c7897f699"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9b785e0818e53eb11abb3e696fab37b0e80c7a866633fc3657e6b3e9434cdec3"
    sha256 cellar: :any_skip_relocation, sonoma:        "073ebafdfab0932bf134f30913180ef678975665d9f8f983f61eedb60a299d9f"
    sha256 cellar: :any_skip_relocation, ventura:       "996619f831a41f6af4a848ba472d93582fbcfbebde6b5f4e679777b36b186fae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e201c0565a68397dddb0f0bcdb5c03a60b1c089013c4c0d38301469c8ceaedd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3eab4be29633cec4a71c15468b49637323b4dbe443ba48b2016acec244a77cd"
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

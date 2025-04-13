class Postgrest < Formula
  desc "Serves a fully RESTful API from any existing PostgreSQL database"
  homepage "https://github.com/PostgREST/postgrest"
  url "https://github.com/PostgREST/postgrest/archive/refs/tags/v12.2.8.tar.gz"
  sha256 "a9012e9c7750164a9e04dc1ccc31636da4eb346873d3654462ac70d44bcc7eb4"
  license "MIT"
  head "https://github.com/PostgREST/postgrest.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "37c277f2d0a7363e91518ec8fea76eb1b46cdeae6b582b47e454bc1bd207ee6f"
    sha256 cellar: :any,                 arm64_sonoma:  "c587e6ff11792323fe92d01307acea1a6ce8c05267dd5d6886eaca8986ed0757"
    sha256 cellar: :any,                 arm64_ventura: "b9a5c1d12c4992083dcb9405d432dbd9d9d53069921eec93c4750cb5885116cf"
    sha256 cellar: :any,                 sonoma:        "a4cd29c2571ba905cd4795c110469a05571280e21966ca9b526aa4d0de09dd2d"
    sha256 cellar: :any,                 ventura:       "02439e24a9a22341862a828f922bac325d6342c4f94c38c0b2f9ac84e709423f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0019b7e8d56b2d19597486b662d20c10f5ef6ad53356727570cbf622c17c0e5"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.8" => :build # GHC 9.10 blocked by deps, e.g. https://github.com/protolude/protolude/issues/149
  depends_on "libpq"

  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", "--ignore-project", *std_cabal_v2_args
  end

  test do
    output = shell_output("#{bin}/postgrest --dump-config 2>&1")
    assert_match "db-anon-role", output
    assert_match "Failed to query database settings for the config parameters", output

    assert_match version.to_s, shell_output("#{bin}/postgrest --version")
  end
end

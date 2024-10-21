class Libsql < Formula
  desc "Fork of SQLite that is both Open Source, and Open Contributions"
  homepage "https://turso.tech/libsql"
  url "https://github.com/tursodatabase/libsql/releases/download/libsql-server-v0.24.27/source.tar.gz"
  sha256 "9d652685ca70490d384ad97cee413e2ad3ca4ec76afa7ef3cd44464b0ed8827f"
  license "MIT"
  head "https://github.com/tursodatabase/libsql.git", branch: "main"

  livecheck do
    url :stable
    regex(/^libsql-server-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "621032055a4a4dd10243abb6fd7e00ed7fa3deb73eb53e85989c752e6af9b4d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b21bfa5453de6694f3813df20fa62342961802d347063e07250c73d5ae97e427"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "936a8460972ca2755b57be688136a5604fbaa3c2d9cdc91ae523a6f84488eb18"
    sha256 cellar: :any_skip_relocation, sonoma:        "7334765d7256513a83ccb0101cf8ecb06a6f5da06f68ea6aaa886eebd48c97ce"
    sha256 cellar: :any_skip_relocation, ventura:       "b7f92fba8a26b4e579b2b6b487bfc05b6bf89a6b7ea4cbf525c4529d131002b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3ccc856f79390c924edda0ee5dd289719c7f96b171a14533d21505ad22c72ec"
  end

  depends_on "rust" => :build

  def install
    ENV["RUSTFLAGS"] = "--cfg tokio_unstable"
    system "cargo", "install", *std_cargo_args(path: "libsql-server")
  end

  test do
    pid = spawn(bin/"sqld")
    sleep 2
    assert_predicate testpath/"data.sqld", :exist?

    assert_match version.to_s, shell_output("#{bin}/sqld --version")
  ensure
    Process.kill("SIGINT", pid)
    Process.wait(pid)
  end
end

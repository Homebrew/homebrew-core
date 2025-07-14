class Libsql < Formula
  desc "Fork of SQLite that is both Open Source, and Open Contributions"
  homepage "https://turso.tech/libsql"
  url "https://github.com/tursodatabase/libsql/releases/download/libsql-server-v0.24.32/source.tar.gz"
  sha256 "51e2b4e99b4a713093d2cd6b69b155ba377d2b1d879744c6dab41f443f01fde8"
  license "MIT"
  head "https://github.com/tursodatabase/libsql.git", branch: "main"

  livecheck do
    url :stable
    regex(/^libsql-server-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae2710fb12075ded23dd2ea2d2ec1dc0467220fe060dee858bd299324c3a3884"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7d4b6a08383ceaf9a4809fe3a7bb2be845a4ee2bf8e7021407727b9426729d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4e6e55398c20c81a0cb5072bf356588ee58f45cb543ada643b3750852451c1c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "c16ab098a60b2e0a66ff82e8c92597e20570cf503f247e638b8b06bc26411052"
    sha256 cellar: :any_skip_relocation, ventura:       "5e2df5e5e206bcfe1e71f1df32bef095dddf1c721f1905749b966c6cfc295568"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9a96d1dee81947a700075f5194f2eae3fab4ff392b04e7ca610ef2cece553f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f08c9c294fffcfb7ea6ab60f148db2bd59386dc1b748f5b394d045639d8fd44"
  end

  depends_on "rust" => :build

  def install
    ENV["RUSTFLAGS"] = "--cfg tokio_unstable"
    system "cargo", "install", *std_cargo_args(path: "libsql-server")
  end

  test do
    pid = spawn(bin/"sqld")
    sleep 2
    sleep 3 if OS.mac? && Hardware::CPU.intel?
    assert_path_exists testpath/"data.sqld"

    assert_match version.to_s, shell_output("#{bin}/sqld --version")
  ensure
    Process.kill("SIGINT", pid)
    Process.wait(pid)
  end
end

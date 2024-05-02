class Libsql < Formula
  desc "Fork of SQLite that is both Open Source, and Open Contributions"
  homepage "https://turso.tech/libsql"
  url "https://github.com/tursodatabase/libsql/releases/download/libsql-server-v0.24.5/source.tar.gz"
  sha256 "d25859643cdab79e765a1020f6d830b0c3e9b0b405b73aa628cd4a365851e570"
  license "MIT"
  head "https://github.com/tursodatabase/libsql.git", branch: "main"

  livecheck do
    url :stable
    regex(/^libsql-server-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2165bf2228b47be36ce80a2c5d02b9fc5e04f067b84cff1f3b1914d96aaf0587"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f518f21cb03ad9ea1a6617ed7815ff8575c7ec7cb83c48b333f4990bb25c895a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "195ee00bdfec371f436b6aea21fe3b2caa590d955563ec9362fb7d5bab99b437"
    sha256 cellar: :any_skip_relocation, sonoma:         "a9aff366b53c15bfd538dbcd3adaec6434e5dba86d920d1a7676afb987fe6853"
    sha256 cellar: :any_skip_relocation, ventura:        "7c03aafaff179341770c00ffda07408beffe328e50c845c1dbb3645f25326b28"
    sha256 cellar: :any_skip_relocation, monterey:       "8c75c363520317483611148509d35fd93b8053bd9ef8971c71ff5792cf7c2f66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "982af3d0e14110c87e6da1f74f778e6f0d0d24db6fd5168d1e41b3cdc6cdec24"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "libsql-server")
  end

  test do
    pid = fork { exec "#{bin}/sqld" }
    sleep 2
    assert_predicate testpath/"data.sqld", :exist?

    output = shell_output("#{bin}/sqld dump --namespace default 2>&1")
    assert_match <<~EOS, output
      PRAGMA foreign_keys=OFF;
      BEGIN TRANSACTION;
      COMMIT;
    EOS

    assert_match version.to_s, shell_output("#{bin}/sqld --version")
  ensure
    Process.kill("SIGINT", pid)
    Process.wait(pid)
  end
end

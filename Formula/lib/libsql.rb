class Libsql < Formula
  desc "Fork of SQLite that is both Open Source, and Open Contributions"
  homepage "https://turso.tech/libsql"
  url "https://github.com/tursodatabase/libsql/releases/download/libsql-server-v0.24.31/source.tar.gz"
  sha256 "ca9a321622e632150166cd5625f48185ba88f8807de41b1105e483c920cacde9"
  license "MIT"
  head "https://github.com/tursodatabase/libsql.git", branch: "main"

  livecheck do
    url :stable
    regex(/^libsql-server-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "124609fd5c7f9bc40ce8ebc9cb699e9c94a38c27d276f0975368cace20e1b841"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99dfa54cfa7e92dbd39d687568c213bca137764c1fe31bb6023b4dca078b8558"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4eb832345e036bbace6c258b2404686f745a1ae9dfbd70c5fe3162b7dbd11101"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ab1beecbb31806bb2c91eb7b6689838dce424f7c3f3dbe7c8dcce4633a8ea59"
    sha256 cellar: :any_skip_relocation, ventura:       "91da9d7836d60ea08a7376ad93fdbcb82ff0d0e48a9edd6baf6f474e911c314e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3cd3c6417971f9591f0db9b26822ad536cfd6564717cf58735fb62814f02343"
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
    assert_predicate testpath/"data.sqld", :exist?

    assert_match version.to_s, shell_output("#{bin}/sqld --version")
  ensure
    Process.kill("SIGINT", pid)
    Process.wait(pid)
  end
end

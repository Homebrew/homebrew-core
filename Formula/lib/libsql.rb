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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "852ee773247ada611ab2328ee7da4489f5b27541f4c563424bc1272bde1ac3dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00ff2b2417e93cf90e6b37f266797b38817bb6f5a118e3143c2ae6544aad0ec1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2119c4641518a4aeca3fef20f3759f951b6e71c55deb6c026d7c9f936965bd26"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "071178b31a2350e85cc4ba7f16330df5b2bf07d7fe37f8c17fed7a24f46bddbb"
    sha256 cellar: :any_skip_relocation, sonoma:        "de5dbd7e67706e8776e45a167129cb6942d913762b8d64b2fab0d5719fb8ec6a"
    sha256 cellar: :any_skip_relocation, ventura:       "20192c95c78d0d17a8a0ae81905c7410c0400a18c0039da43154d9860412712f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c72a00eb9105bb84ef2c118047457bb3ae9ef93efa85ea6a6ee30fcb25720ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca0ca891c69501aa629a51785058ae16a647bbfdf6881bc56f59e735b6143280"
  end

  depends_on "rust" => :build

  def install
    ENV.append_to_rustflags "--cfg tokio_unstable"
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

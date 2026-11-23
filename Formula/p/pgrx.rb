class Pgrx < Formula
  desc "Build Postgres Extensions with Rust"
  homepage "https://github.com/pgcentralfoundation/pgrx"
  url "https://github.com/pgcentralfoundation/pgrx/archive/refs/tags/v0.20.1.tar.gz"
  sha256 "3ccc7efc9a9964723fb90694f7e02b78168ff1f912bc37c4623e155c3f0e9fa3"
  license "MIT"

  bottle do
    manifest_sha256 "a74278a3c84a35dcaba91d7ce46f1288cf8d25cdeb3d90e182caeec8b3682ab7"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "907ff96f4812486fd4ef9c835c0798751c38f64396a4fb78fba41a9b15f742cd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9d27589a5707eb6cbe294b15d9f8bc7645b6c4f82049d9db21ef95dd7984bf0c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "317e96f1b4cca344d377cfaab44d90ec44063257d58fca1f2dc077379cc0b72d"
    sha256 cellar: :any,                 arm64_linux:       "d7a47a40600129db59a35adfdaefec957ff62cd8016f2d9db8550c89622b4a21"
    sha256 cellar: :any,                 x86_64_linux:      "836276b4ccc54483e386dc20cd2c049bc56dbf67ffc00c553423153f77925f24"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => [:build, :test]

  on_linux do
    depends_on "openssl@4"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cargo-pgrx")
  end

  test do
    system formula_opt_bin("rust")/"cargo", "pgrx", "new", "my_extension"
    assert_path_exists testpath/"my_extension/my_extension.control"
  end
end

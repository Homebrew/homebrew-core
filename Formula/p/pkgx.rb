class Pkgx < Formula
  desc "Standalone binary that can run anything"
  homepage "https://pkgx.sh"
  license "Apache-2.0"
  head "https://github.com/pkgxdev/pkgx.git", branch: "main"

  stable do
    url "https://github.com/pkgxdev/pkgx/archive/refs/tags/v2.10.3.tar.gz"
    sha256 "6df90a10139006a9ab36102b1e4394a2a6741120b197d1e84da7ec3b9f211b95"

    # Backport openssl-sys update needed to build with OpenSSL 4
    patch do
      url "https://github.com/pkgxdev/pkgx/commit/ec8315d84a89b4130c83171e6405c6e8d6694ab9.patch?full_index=1"
      sha256 "aeb26601c94ac781e4d943d31e2dd8785afcd3d84ae203f791c1d0636c83d1c7"
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "594d5f7d2a67216e10aef367e2d049171958c1e9b5a438415e65042f4d56ccc8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db16c2e9fb6114129e726455948f480c91ad2533979053e1d2669eb285a426f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8c13ca08dd82b764332e380de7e2c29867611413505b34100d3085c37f287f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "82c33610913fdb44208e8bdec8da5e97fa025425ca1ffe186e0409849a9be2fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ff5de376cabade58750645ffdec396132873d59eeeb07db2f57c3f2b5b8c0d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc78cc56979bfa54e202ee5ff404c4231a606c14cfb2902340ca34b40417c0f9"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "sqlite"

  on_linux do
    depends_on "openssl@4" => :build
  end

  def install
    ENV["LIBSQLITE3_SYS_USE_PKG_CONFIG"] = "1"
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@4"].opt_prefix if OS.linux?

    system "cargo", "install", *std_cargo_args(path: "crates/cli")
  end

  test do
    (testpath/"main.go").write <<~GO
      package main

      func main() {
        println("Hello world")
      }
    GO
    assert_match "1.23", shell_output("#{bin}/pkgx go@1.23 version")
    assert_match "Hello world", shell_output("#{bin}/pkgx go@1.23 run main.go 2>&1")
  end
end

class Fend < Formula
  desc "Arbitrary-precision unit-aware calculator"
  homepage "https://printfn.github.io/fend"
  url "https://github.com/printfn/fend/archive/refs/tags/v1.4.5.tar.gz"
  sha256 "1bf65941f690ef6f0c95cf2485e6675bd35c3a46725fe9d1ed06c810c1a05b22"
  license "GPL-3.0-or-later"
  head "https://github.com/printfn/fend.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a31f9eff85aa80dd83cebcc1242a92398cb1dd9068d8f15c7174c54369dd2d52"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e3cdb5e72dba88bf759ab8b9f5484669e5084e529be19a7ad3720484e959f204"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc5cdbc94302edbc027bce8edb0edb384c3e170ab4f1919dc5a40467678c74c9"
    sha256 cellar: :any_skip_relocation, sonoma:         "538ea5488dc647c915107c2bc329605c37dd69599b31c0ef91277b1cd20c5744"
    sha256 cellar: :any_skip_relocation, ventura:        "1e1fe485760335a878a1b079bedd4c07529eeb49a93825ff3d029655c9cb04e8"
    sha256 cellar: :any_skip_relocation, monterey:       "68372d9cd25258ba3623bd010ecff1dce7d0e6c4496d019f05bbf9c5184b6b07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ec9a1379bb8cefce46af72a751360962bd07d51b6bb4656e781a7ef18756b3b"
  end

  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "cli")
    system "./documentation/build.sh"
    man1.install "documentation/fend.1"
  end

  test do
    assert_equal "1000 m", shell_output("#{bin}/fend 1 km to m").strip
  end
end

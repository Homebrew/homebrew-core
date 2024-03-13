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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "34d2b802619168997deb0badd275c4310ea7857e99adcb652894b2706918d99c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7d9bc836ca0e4a1814c8f2139dda53cebeb3cd8aed0b0e86ce34a6ea9f219f9c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "87d2bde39c21c82da4291b3227987331710962e3cb860d6c27a950d94f2c7f67"
    sha256 cellar: :any_skip_relocation, sonoma:         "37dc7dd9ce90e89da8d7c81ac4d54f52d03abd19e541857464d9a0f82f2d424a"
    sha256 cellar: :any_skip_relocation, ventura:        "59e88850dc352e28a9783df862b12831916d5b053ce407390e8ae7241aa7c269"
    sha256 cellar: :any_skip_relocation, monterey:       "6642f4eb142540d7c6a73e4f0095eaef2676b35ea2ea99203a65ac9fbcc6a68f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04243be14d0725a9bd89ef820fba209f49ebc60eedb5a54ecabfb1b05bc1794f"
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

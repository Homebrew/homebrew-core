class ForgejoCli < Formula
  desc "CLI tool for interacting with Forgejo"
  homepage "https://codeberg.org/forgejo-contrib/forgejo-cli"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://codeberg.org/forgejo-contrib/forgejo-cli.git", branch: "main"

  stable do
    url "https://static.crates.io/crates/forgejo-cli/forgejo-cli-0.6.0.crate"
    sha256 "4d56acd6ab5caab2870d6e301cd6e42741ca98761fc1d5890dad09b21b44780e"

    # Fix issue with shell completions.
    # Remove with `stable` block with next release.
    patch do
      url "https://codeberg.org/forgejo-contrib/forgejo-cli/commit/42136622787b3a289b80565d2756263394dda855.patch"
      sha256 "f1ac36eb47411b1c11b1200de1750040a94f456b26655eeab1971c3767b28bec"
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "90f243937e4a0101b73ad9d50c413f416aef02374aeb2c9344ff8a9151944fc3"
    sha256 cellar: :any, arm64_sequoia: "b476de6d721cbbdbe3d3787af230cad5763445dfdebe235a6163d74b640e9ae6"
    sha256 cellar: :any, arm64_sonoma:  "aa0820a87a9905e33308c795156e56f7fc4ffa7801332c79aff99c41b2024727"
    sha256 cellar: :any, sonoma:        "7b0178a4c92fd7b556843adbc2633b11294da014f2b4d38d8a0c0d709e741413"
    sha256 cellar: :any, arm64_linux:   "5b66b0f4d1ba7b3b45c341292fbc15ea2009271f665ae3ac567e68602b5cea69"
    sha256 cellar: :any, x86_64_linux:  "f5b403159bbead7abdc9db660d024559b4eed17799b9e5f32e5ba034c8a22ef8"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"fj", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fj version")

    assert_match "Beyond coding. We forge.", shell_output("#{bin}/fj repo view codeberg.org/forgejo/forgejo")
  end
end

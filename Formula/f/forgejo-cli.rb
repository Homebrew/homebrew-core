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
    rebuild 2
    sha256 cellar: :any, arm64_golden_gate: "17bc4ce1953a7efb24ebadd360ba2156b356599be9fcc8e7d9d8e586b01f007e"
    sha256 cellar: :any, arm64_tahoe:       "bb4370c4503b1feefe1cdbab8600560eb5ec835f3b21558dbee10571a8a06b07"
    sha256 cellar: :any, arm64_sequoia:     "870b77f42e1e571568d9e8d4d9e0fc319fa1244b76d21ddb35e1c9a8282b38ff"
    sha256 cellar: :any, arm64_sonoma:      "a005e1e6a4af9b758807729c633a3eadd197f0d1a30360ecdcf1cb463e776fba"
    sha256 cellar: :any, arm64_linux:       "47e4ec22711a753fbc539a9ce817ba6b2670736254c1685255f6bc0b16e9a18d"
    sha256 cellar: :any, x86_64_linux:      "8c30ca23f99312e2b6cb420b5308673890063e8abf61dc8981b98cfe301d4bc2"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

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

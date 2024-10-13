class Geph4 < Formula
  desc "Modular Internet censorship circumvention system to deal with national filtering"
  homepage "https://geph.io/"
  url "https://github.com/geph-official/geph4-client/archive/refs/tags/v4.99.8.tar.gz"
  sha256 "3925c16f35d1b10705b36f2a19ef9fda596cb0d07bd6bab2e1e7b9b0ce7a2c72"
  license "GPL-3.0-only"
  head "https://github.com/geph-official/geph4-client.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b919bafb02ced4c2324e6890c5e4a2eb58c0465f2776863a9fb9e122bf0d2cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a7ed24a5b9d7dee353de07f35afa7b7a6c8cc68b16149dfd768b99d1bc853bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8f412ad80864741a26b3bf2ebdd602960565a8f10d0a3ef3724d8900c464213a"
    sha256 cellar: :any_skip_relocation, sonoma:        "677760fb46ff4e7396436824390d0705a201111978e264165b6c3fb6fcb7e7a1"
    sha256 cellar: :any_skip_relocation, ventura:       "c99580b0dbb2b059c698847a2061ce7b6e81a4f3abdf49679c004452a9b9b0d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b972d152bcf60ad799429c4220ba79629c66ab4aefee49b4fd880256c190912"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    rm_r(buildpath/".cargo")
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/geph4-client sync --credential-cache ~/test.db auth-password 2>&1", 1)
    assert_match "incorrect credentials", output

    assert_match version.to_s, shell_output("#{bin}/geph4-client --version")
  end
end

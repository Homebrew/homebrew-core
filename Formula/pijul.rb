class Pijul < Formula
  desc "Patch-based distributed version control system"
  homepage "https://pijul.org"
  url "https://pijul.org/releases/pijul-0.10.0.tar.gz"
  sha256 "da3fcba4ab39a4371cda7273691364c2355c9b216bb7867d92dae5812ebb71d2"

  bottle do
    sha256 "f3a26a1788fc22994cb3523a776f137bcb2cd40af185ac6a4a3419a4b7909354" => :mojave
    sha256 "471d6fe7837fa61170561c1e19d5a0fe455bae57a5a793b4e087cc3ff0d49e41" => :high_sierra
    sha256 "8682e459dd342214e3524ecb8849e19dbf38ec5a91fc192d1818d44f1d8e84d7" => :sierra
    sha256 "6343c522e7fe764dee0141721648060078f20364df4d2c3100683ed1063adf6a" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libsodium"
  depends_on "openssl"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = Formula["openssl"].opt_prefix

    cd "pijul" do
      system "cargo", "install", "--root", prefix, "--path", "."
    end
  end

  test do
    system bin/"pijul", "init"
    %w[haunted house].each { |f| touch testpath/f }
    system bin/"pijul", "add", "haunted", "house"
    system bin/"pijul", "record", "--all",
                                  "--message='Initial Patch'",
                                  "--author='Foo Bar <baz@example.com>'"
    assert_equal "haunted\nhouse\n", shell_output("#{bin}/pijul ls")
  end
end

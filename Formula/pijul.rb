class Pijul < Formula
  desc "Patch-based distributed version control system"
  homepage "https://pijul.org"
  url "https://pijul.org/releases/pijul-0.10.0.tar.gz"
  sha256 "da3fcba4ab39a4371cda7273691364c2355c9b216bb7867d92dae5812ebb71d2"

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libsodium"
  depends_on "openssl"

  def install
    # Ensure that the `openssl-sys` crate picks up the intended library.
    # (If we’re not careful, LibreSSL or OpenSSL 1.1 gets used instead.)
    ENV["OPENSSL_DIR"] = Formula["openssl"].opt_prefix

    cd "pijul" do
      system "cargo", "install", "--root", prefix
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

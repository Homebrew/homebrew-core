class Pijul < Formula
  desc "Patch-based distributed version control system"
  homepage "https://pijul.org"
  url "https://pijul.org/releases/pijul-0.12.0.tar.gz"
  sha256 "987820fa2a6fe92a9f516f5e9b41ad59a597973e72cb0c7a44ca0f38e741a7e6"
  revision 1

  bottle do
    cellar :any
    sha256 "dcf72f0e36078c8ef880e98be7f3a2498e9028cedea19487a2d170818c0f86da" => :mojave
    sha256 "eb2ef679e6622886d0ed491c8612d6e45fda762a02ff98638786939bc13b3ac3" => :high_sierra
    sha256 "e7f2821b461697e285f209b46cc67c3101bae51552acd7934b9145b9630148cd" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libsodium"
  depends_on "nettle"
  depends_on "openssl@1.1"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix

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

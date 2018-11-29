class Pijul < Formula
  desc "Patch-based distributed version control system"
  homepage "https://pijul.org"
  url "https://pijul.org/releases/pijul-0.11.0.tar.gz"
  sha256 "e60793ab124e9054c1d5509698acbae507ebb2fab5364d964067bc9ae8b6b5e5"

  bottle do
    sha256 "ed13c0d4328ed2c0fd47213410ccbc6c2ff63580d5219cdf26bb8e7c745b9f4a" => :mojave
    sha256 "531e458e6d68d5dd6a32ae16a3b31a861c6cdcdec9450fbf4add7af65a341402" => :high_sierra
    sha256 "63de9a8e4eef6dc1778192456db5b3470a2ef7cacb327128e032f188099a0107" => :sierra
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

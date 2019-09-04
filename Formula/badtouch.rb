class Badtouch < Formula
  desc "Scriptable network authentication cracker"
  homepage "https://github.com/kpcyrd/badtouch"
  url "https://github.com/kpcyrd/badtouch/archive/v0.7.0.tar.gz"
  sha256 "d49eb11825ab56245f82f0958a89ea69edf558c1bd142afba2d4408dc9d20fbb"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "c38c3d095c361bdefa7b36ca860dc49eefebdb0f7c4437d73ab4d7898a196b18" => :mojave
    sha256 "bbaa6687356e667f39dfe30e478e820d49ca65e3294902f8bde4f1d7c6432837" => :high_sierra
    sha256 "dd1fb28b935a06d05de233d28f4fae19f61856055cc0bf4071b4bbe59111e2c8" => :sierra
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix

    system "cargo", "install", "--root", prefix, "--path", "."
    man1.install "docs/badtouch.1"
  end

  test do
    (testpath/"true.lua").write <<~EOS
      descr = "always true"

      function verify(user, password)
          return true
      end
    EOS
    system "#{bin}/badtouch", "oneshot", "-vvx", testpath/"true.lua", "foo"
  end
end

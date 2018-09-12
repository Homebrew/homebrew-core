class Badtouch < Formula
  desc "Scriptable network authentication cracker"
  homepage "https://github.com/kpcyrd/badtouch"
  url "https://github.com/kpcyrd/badtouch/archive/v0.6.1.tar.gz"
  sha256 "62181ac05a68a552e1984dd42206f6a5ca195e51addc48cbfdf55a60afc7c3ae"

  bottle do
    sha256 "0adb1b9292c93963822e090e4860c6deadbdd2cc7da9d0e49639fa4a181cb425" => :mojave
    sha256 "4965a902bbe8a22452039b145d5937f785fdac750674dc3c44ada3ca822c4aa4" => :high_sierra
    sha256 "0d24c83275c2988cb09befda551377ee9b803fffdfca094bb4649dbdc2624899" => :sierra
    sha256 "f579fb45cbfd1ee3908f5afd25c91c017d68ab380a8d2d36dc125fcd5031b293" => :el_capitan
  end

  depends_on "rust" => :build
  depends_on "openssl"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = Formula["openssl"].opt_prefix

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

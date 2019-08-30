class Badtouch < Formula
  desc "Scriptable network authentication cracker"
  homepage "https://github.com/kpcyrd/badtouch"
  url "https://github.com/kpcyrd/badtouch/archive/v0.7.0.tar.gz"
  sha256 "d49eb11825ab56245f82f0958a89ea69edf558c1bd142afba2d4408dc9d20fbb"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "4eecd98779c60f00a1060813bc2bbd66f3f223ad369ab463750df9f6a4bd0c8e" => :mojave
    sha256 "02c3fe748b8b48754827a468b8fc9825c614a1e2a6585818612ce9d8e3ab39c3" => :high_sierra
    sha256 "100a8b53f7e2f540ab447382ca44b6f4368a189a2ad069caa71c555ca464c04e" => :sierra
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

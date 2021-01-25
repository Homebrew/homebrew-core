class Badtouch < Formula
  desc "Scriptable network authentication cracker"
  homepage "https://github.com/kpcyrd/badtouch"
  url "https://github.com/kpcyrd/badtouch/archive/v0.7.3.tar.gz"
  sha256 "cb09ae83bbe37e17ce1d5e86ba1c9f8b8dd1dc1b30e3f7d69d7cfd8db7ae5547"
  license "GPL-3.0-or-later"

  bottle do
    cellar :any_skip_relocation
    sha256 "31133f02d762c17de4ab1d60a27874a6c4f33cf4a677257e1b446872315b3195" => :big_sur
    sha256 "b3e471e7e4e1192a6a24328ca48eeb23214743aca9c9296cec9aebeb248db263" => :arm64_big_sur
    sha256 "df8dc24dfe3aa1ceabdd61fe783fb7edd8aa8de8ab558d98002e330eaf37ee50" => :catalina
    sha256 "5459ee6e2d462ebc1c7ea33f3139bbe9a482859876a9f163cf61e80fae9c12d6" => :mojave
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix

    system "cargo", "install", *std_cargo_args
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

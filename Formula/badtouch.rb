class Badtouch < Formula
  desc "Scriptable network authentication cracker"
  homepage "https://github.com/kpcyrd/badtouch"
  url "https://github.com/kpcyrd/badtouch/archive/v0.7.3.tar.gz"
  sha256 "cb09ae83bbe37e17ce1d5e86ba1c9f8b8dd1dc1b30e3f7d69d7cfd8db7ae5547"
  license "GPL-3.0-or-later"

  bottle do
    cellar :any_skip_relocation
    sha256 "fbda9466878cce291a17cfcfba0d10f99ee243946282130f87387822f8453bc6" => :big_sur
    sha256 "f6294a3dc8e19096623409df112ed32d30005d7ea9539529b39d374b21c6d4ac" => :catalina
    sha256 "4ac7d4d570c30b3f024a276f50aa39429350a852efd5c29e4941d66dbe7227f6" => :mojave
    sha256 "e4f2eb394ebc2c5f2b674d577ef2263b6580927d1b0eb15ee38384fbfb6565f4" => :high_sierra
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

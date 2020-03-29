class Badtouch < Formula
  desc "Scriptable network authentication cracker"
  homepage "https://github.com/kpcyrd/badtouch"
  url "https://github.com/kpcyrd/badtouch/archive/v0.7.1.tar.gz"
  sha256 "c188bb1df106761a436fd25d3530323a47633c4c937d186e82c00981ffc94b5f"

  bottle do
    cellar :any_skip_relocation
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

    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
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

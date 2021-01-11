class Badtouch < Formula
  desc "Scriptable network authentication cracker"
  homepage "https://github.com/kpcyrd/badtouch"
  url "https://github.com/kpcyrd/badtouch/archive/v0.7.2.tar.gz"
  sha256 "f3e384ccd9ff90c19f081c8cb240aff28bac42e7b318b5a04f50a70fc75537a4"
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

  # Patch to avoid ULIMIT failures on Mojave and Catalina. Remove at version bump.
  # https://github.com/kpcyrd/badtouch/pull/79
  patch do
    url "https://github.com/kpcyrd/badtouch/commit/0fe3c3fe877ccf948b8fe1b4eaa1a34de6d84882.patch?full_index=1"
    sha256 "ff22b7a8a2047502f3a486bd4c7853466da702f93f673e0c8c6a3cd79f119886"
  end

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

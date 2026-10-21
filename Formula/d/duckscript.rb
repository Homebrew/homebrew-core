class Duckscript < Formula
  desc "Simple, extendable and embeddable scripting language"
  homepage "https://sagiegurari.github.io/duckscript"
  url "https://github.com/sagiegurari/duckscript/archive/refs/tags/0.11.1.tar.gz"
  sha256 "2e23b16359fb9b2c521f0bd250f6eb754bcb8ef40a7f8bf8076f87387276032a"
  license "Apache-2.0"
  head "https://github.com/sagiegurari/duckscript.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "85dff50620212b1131a69adc0c3d049d3f104b0a5f1d893736412aee39dea451"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fac39965b287a7a902b514a7aa9c1e735925914521e5b477001a74fc8353db50"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "88738c2f2440ce279be8dc4a4be77af2358d214a74f809fb7b3bff6672d56cc9"
    sha256 cellar: :any,                 arm64_linux:       "8c96048f672a0902dd41db269145519b9fb084d1600c5e3ff376e86056a9b25e"
    sha256 cellar: :any,                 x86_64_linux:      "7ed735f2fa7cad3adfbdf80e812ab2c987fbb7f08588cac11d16f36803d13339"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@4" # Uses Secure Transport on macOS
  end

  conflicts_with "duck", because: "both install `duck` binaries"

  deny_network_access!

  def fetch
    # Update to openssl 0.10.78 and openssl-sys 0.9.114 for minimum needed to use OpenSSL 4
    if build.stable?
      openssl_sys_version = File.read("Cargo.lock")[/name = "openssl-sys"\nversion = "(\d+(?:\.\d+)+)/i, 1]
      odie "Remove `cargo update` workaround!" if Version.new("0.9.114") <= openssl_sys_version
    end
    system "cargo", "update", "openssl-sys", "--precise", "0.9.114"
    system "cargo", "update", "openssl", "--precise", "0.10.78"

    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # Replace tls-rustls with tls-native
    features = "tls-native"
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "duckscript_cli", features:)
  end

  test do
    (testpath/"hello.ds").write <<~EOS
      out = set "Hello World"
      echo The out variable holds the value: ${out}
    EOS
    output = shell_output("#{bin}/duck hello.ds")
    assert_match "The out variable holds the value: Hello World", output
  end
end

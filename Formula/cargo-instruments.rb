class CargoInstruments < Formula
  desc "Easily generate Instruments traces for your rust crate"
  homepage "https://github.com/cmyr/cargo-instruments"
  url "https://github.com/cmyr/cargo-instruments/archive/v0.3.1.tar.gz"
  sha256 "55a71300045a689b9a416a4367b0c1f6823c5bc837156e774bfd52eba105726f"

  bottle do
    cellar :any
    sha256 "570ef6a76ad8b73cec931652ce50375dc3a334ed5b9f59a0120d52f4c677b5f8" => :catalina
    sha256 "fd54b752b6dcacb30b861039f6a16109ca83072966651f0f62a50dc0e45c4360" => :mojave
    sha256 "7cf3cf504a8ef58922cd115a26d0cda9b922d23f29f53d1a2aece21c855e846a" => :high_sierra
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    output = shell_output "#{bin}/cargo-instruments instruments", 1
    assert_match output, "could not find `Cargo.toml` in `#{Dir.pwd}` or any parent directory"
  end
end

class CargoInstruments < Formula
  desc "Easily generate Instruments traces for your rust crate"
  homepage "https://github.com/cmyr/cargo-instruments"
  url "https://github.com/cmyr/cargo-instruments/archive/v0.3.4.tar.gz"
  sha256 "d9549e7bf0fb31b506a2d838029650f624a352146d968e60d653bac10c5fd1da"
  license "MIT"

  bottle do
    cellar :any
    sha256 "131aaf3d9347d12853503afdb1bdd94b27e84ff665e105a35eeac2edb3e7d736" => :big_sur
    sha256 "3b55dda8cb06ac96e43545dbc5424170d3ce43dbd8450191af3ba32e0a059184" => :arm64_big_sur
    sha256 "eec9683c797fc7e8d800f6131b61998619390a8723bb5fe3171e185c72d53caf" => :catalina
    sha256 "ede51dd3eead58236d0de240a86f649e00c584be7a438792ff3eb04a9287ad4a" => :mojave
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output "#{bin}/cargo-instruments instruments", 1
    assert_match output, "could not find `Cargo.toml` in `#{Dir.pwd}` or any parent directory"
  end
end

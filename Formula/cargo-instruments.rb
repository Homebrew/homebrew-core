class CargoInstruments < Formula
  desc "Easily generate Instruments traces for your rust crate"
  homepage "https://github.com/cmyr/cargo-instruments"
  url "https://github.com/cmyr/cargo-instruments/archive/v0.4.0.tar.gz"
  sha256 "702619ecf72637f768c00344236bdeeee3df819a3e73b5495f3e5690a6467dc1"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "3b55dda8cb06ac96e43545dbc5424170d3ce43dbd8450191af3ba32e0a059184"
    sha256 cellar: :any, big_sur:       "131aaf3d9347d12853503afdb1bdd94b27e84ff665e105a35eeac2edb3e7d736"
    sha256 cellar: :any, catalina:      "eec9683c797fc7e8d800f6131b61998619390a8723bb5fe3171e185c72d53caf"
    sha256 cellar: :any, mojave:        "ede51dd3eead58236d0de240a86f649e00c584be7a438792ff3eb04a9287ad4a"
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

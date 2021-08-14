class CargoInstruments < Formula
  desc "Easily generate Instruments traces for your rust crate"
  homepage "https://github.com/cmyr/cargo-instruments"
  url "https://github.com/cmyr/cargo-instruments/archive/v0.4.1.tar.gz"
  sha256 "80eda3959bfe167d9df050df82fdeac0aec5606bb02384e2b4313a472bcb599e"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "27d1412ae371b1e8a555a9ed66a79df685c170f45cdbda124c5f0c520ee997cd"
    sha256 cellar: :any, big_sur:       "521c4f9983ffc40a9ec1da642c3d9757e1cb169cadd4f2c0d2f1480e074a0c94"
    sha256 cellar: :any, catalina:      "022db59b1bd0cbd1c209a7d4837f510a1ce8db6d2d4eb7ced7924e2370dcee16"
    sha256 cellar: :any, mojave:        "a18ede354dc88113c06e6a4f3a70f2408671b8fd5edaebb6498bdb0b8640cf62"
  end

  depends_on "rust" => :build
  depends_on :macos
  depends_on "openssl@1.1"

  # Support rust 1.54, remove with next release after 0.4.1
  patch do
    url "https://github.com/cmyr/cargo-instruments/commit/5371c086007e15da55360fdea2e3b8e79cff002b.patch?full_index=1"
    sha256 "73e4e95de7052d2c9393037a7b6f32dd16933c67615693b3e70722f4cf97c334"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output "#{bin}/cargo-instruments instruments", 1
    assert_match output, "could not find `Cargo.toml` in `#{Dir.pwd}` or any parent directory"
  end
end

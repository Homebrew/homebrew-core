class Macchina < Formula
  desc "System information fetcher, with an emphasis on performance and minimalism"
  homepage "https://github.com/Macchina-CLI/macchina"
  url "https://github.com/Macchina-CLI/macchina/archive/refs/tags/v6.2.1.tar.gz"
  sha256 "87a38bde067fadd96615899d6a8b9efdb238a4bd3859008be47b3e4c2a02c607"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "765abf4474d4cb68627df0bc428202918dc55cd1c68b39ba88f0303a3d418990"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b720d3c8c9568455139815334ca4496932f9f3ec7330e44aa796377ec1fb1aba"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c356c873aae2486bf6ba6720f810f5b0ec193a53dd3d6d7ff756777f4d4ba555"
    sha256 cellar: :any_skip_relocation, sonoma:        "de544a806f0982f2899ae4c2e944594a02a0c6212c3678037baed460a221ca96"
    sha256 cellar: :any_skip_relocation, ventura:       "f59ec7769b594b3b1991dcb05a4294f6d17da79fb53a76da03d2e308383e43d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1a6d75144ef0177ae802f25d5345a52f6e7db2c81a465c30b6665f0e2f99b86"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "We've collected a total of 20 readouts", shell_output("#{bin}/macchina --doctor")
  end
end

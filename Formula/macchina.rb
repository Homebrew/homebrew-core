class Macchina < Formula
  desc "System information fetcher, with an emphasis on performance and minimalism"
  homepage "https://github.com/Macchina-CLI/macchina"
  url "https://github.com/Macchina-CLI/macchina/archive/v1.1.3.tar.gz"
  sha256 "57dddd11445fcc6f696e4fc5bc0ba102caab033d2c4614c1cf10ae6a5fa82988"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "59afa520fbaa6912141e191e7eb5b9c3651f7475b194ee4e93d6308edb7507a4"
    sha256 cellar: :any_skip_relocation, big_sur:       "ee403cfd5c2525cff26c674910e63c479492eb986375370cd3435c7381424589"
    sha256 cellar: :any_skip_relocation, catalina:      "b0511c19cbb873298a86e479aec549a42334498e0352a9cc8ad4c788257494e1"
    sha256 cellar: :any_skip_relocation, mojave:        "8853c91543ccfa82e5d4d3b6ef1aea32f30c3ff79b308c3288d3c23afc117161"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7633cd5aab207912ddc73c0689942d2d4645a89385a169210a4a98acdc79f437"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Let's check your system for errors...", shell_output("#{bin}/macchina --doctor")
  end
end

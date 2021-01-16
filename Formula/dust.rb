class Dust < Formula
  desc "More intuitive version of du in rust"
  homepage "https://github.com/bootandy/dust"
  url "https://github.com/bootandy/dust/archive/v0.5.4.tar.gz"
  sha256 "395f0d5f44d5000468dc51a195e4b8e8c0b710a1c75956fb1f9ad08f2fbbc935"
  license "Apache-2.0"
  head "https://github.com/bootandy/dust.git"

  livecheck do
    url :head
    regex(/v([\d.]+)/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "bfcdb4a3fe8417d4bb88d1b0945b002e818271a8b1f5e7ac3a9502763c0e4157" => :big_sur
    sha256 "88a327584a516af51e1b5a27b918f705fb06694b11f81cc2fd91fc78bf1f0f79" => :arm64_big_sur
    sha256 "693714f8f0d1207b8e54357f924e3a1242dd54d93f21de76b669217812065711" => :catalina
    sha256 "4c5c1cda666e8d405cf39ae79b3327dd8581555c18417b0834c2d334ad4568ed" => :mojave
    sha256 "52750a57ee2e58c7b95661b61cb0d855ba653946f6f21881ed041f2ce2cea747" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match /\d+.+?\./, shell_output("#{bin}/dust -n 1")
  end
end

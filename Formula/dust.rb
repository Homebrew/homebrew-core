class Dust < Formula
  desc "More intuitive version of du in rust"
  homepage "https://github.com/bootandy/dust"
  url "https://github.com/bootandy/dust/archive/v0.5.3.tar.gz"
  sha256 "f8401257e1cae721019da05a11dd00c2f114121ccd525452b783d472da59b6e8"
  license "Apache-2.0"
  head "https://github.com/bootandy/dust.git"

  livecheck do
    url :head
    regex(/v([\d.]+)/i)
  end

  bottle do
    cellar :any_skip_relocation
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

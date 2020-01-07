class Dtool < Formula
  desc "Command-line tool collection to assist development"
  homepage "https://github.com/guoxbin/dtool"
  url "https://github.com/guoxbin/dtool/archive/v0.4.0.tar.gz"
  sha256 "05ee5d3e4669d778d8e0c33a51d491607e382731cdc541a7cc8b38e75e57826b"

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    assert_match "0x61626364", shell_output("#{bin}/dtool s2h abcd")
  end
end

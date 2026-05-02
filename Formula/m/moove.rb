class Moove < Formula
  desc "Manipulate file names and locations using a text editor"
  homepage "https://github.com/urin/moove"
  url "https://github.com/urin/moove/archive/refs/tags/v0.4.3.tar.gz"
  sha256 "93c5051c79519c466d8d65d793f4ed8daa4f4bfecacf6f00c11bf4d786ded05f"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/urin/moove.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/moove --version")
  end
end

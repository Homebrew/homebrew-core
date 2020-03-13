class Procs < Formula
  desc "Modern replacement for ps written by Rust"
  homepage "https://github.com/dalance/procs"
  url "https://github.com/dalance/procs/archive/v0.9.20.tar.gz"
  sha256 "509e8085a7b68c4084e9940ad418e03b4704cef518f6de55e5b3f421f4639a36"

  bottle do
    cellar :any_skip_relocation
    sha256 "aeae4394db022ea1e049d92bb32b9efd7b29ca5567bffccc5f289ef659dc5e65" => :catalina
    sha256 "6503897df3ffc8b664f77ef29f74de6115bb0805a2ac48be95e5eb2dbb342e8b" => :mojave
    sha256 "3aa8ffdd03db2a7378cb9788a65321d84716e277e4b3854a64c5f573b0de9a76" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    output = shell_output("#{bin}/procs")
    count = output.lines.count
    assert count > 2
    assert output.start_with?(" PID:")
  end
end

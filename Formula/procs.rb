class Procs < Formula
  desc "Modern replacement for ps written by Rust"
  homepage "https://github.com/dalance/procs"
  url "https://github.com/dalance/procs/archive/v0.9.20.tar.gz"
  sha256 "509e8085a7b68c4084e9940ad418e03b4704cef518f6de55e5b3f421f4639a36"

  bottle do
    cellar :any_skip_relocation
    sha256 "fa34ec430e3f88c9bc4a661c3811c6192113126695ab6d0b90a00a26f8e9600d" => :catalina
    sha256 "856859199b6da8038e88cc630090fb3dad60020e8ce1b70fc35051c57f5e1ba2" => :mojave
    sha256 "d5f0912cd01c372a93b7cfb60ebd2c86e0bb24d13fcd0ee2a1a2404a4ca10fba" => :high_sierra
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

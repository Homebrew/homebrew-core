class Procs < Formula
  desc "Modern replacement for ps written by Rust"
  homepage "https://github.com/dalance/procs"
  url "https://github.com/dalance/procs/archive/v0.9.9.tar.gz"
  sha256 "414b40fc56ee57dda7ba8b07d8cecd6811cf702474c9f1c922a619ee5d597223"

  bottle do
    cellar :any_skip_relocation
    sha256 "afb83ea340dd2d4afc89e897e1d300b74a3cbbc00b43a956ecfca79a0d30b291" => :catalina
    sha256 "7df07639eca8edd6382ef39b8c04fbe62b130f9125e9a617ba5d1d28c27c7a94" => :mojave
    sha256 "2d77df66127b1ad242cad0250aeca50c1c8692061d5c405ea7b17604b636c8ee" => :high_sierra
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

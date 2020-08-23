class Corral < Formula
  desc "Dependency manager for the Pony language"
  homepage "https://github.com/ponylang/corral"
  url "https://github.com/ponylang/corral/archive/0.4.0.tar.gz"
  sha256 "5c74eef22c8481330bf23fdf7f8477667c56c3ef4442f1490e80795ddcf3be7f"
  license "BSD-2-Clause"
  head "https://github.com/ponylang/corral.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bf397d0dbb3a63d8347546fa082a854b196f39a2a23263c00eb4fda8d0265a1a" => :catalina
    sha256 "309858fccac2b1015620240276b2bb53955ea37160632231d88d0deff70931f9" => :mojave
    sha256 "7a8958c3ce14b94054ca831330f459e84848eac1a6fab7298b02abda185a974f" => :high_sierra
  end

  depends_on "ponyc"

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    (testpath/"test/main.pony").write <<~EOS
      actor Main
        new create(env: Env) =>
          env.out.print("Hello World!")
    EOS
    system "#{bin}/corral", "run", "--", "ponyc", "test"
    assert_equal "Hello World!", shell_output("./test1").chomp
  end
end

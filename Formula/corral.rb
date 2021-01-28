class Corral < Formula
  desc "Dependency manager for the Pony language"
  homepage "https://github.com/ponylang/corral"
  url "https://github.com/ponylang/corral/archive/0.4.1.tar.gz"
  sha256 "ea829e1766c13c6813cecc6e9f492746e4b38304b05c742013b5504454d73d2b"
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

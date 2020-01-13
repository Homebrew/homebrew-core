class Higan < Formula
  desc "Multi-system emulator for games"
  homepage "https://byuu.org/higan"
  url "https://github.com/byuu/higan/archive/v107.tar.gz"
  sha256 "ac7aaabd88f3cde2915a435d11ba70f5570e1a2c17bbb572cf56fb9644dbc30f"
  head "https://github.com/byuu/higan.git"

  def install
    system "make", "-C", "higan", "local=false"
    system "make", "-C", "icarus"
    # Move to libexec to expose to `brew linkapps`
    libexec.mkpath
    mv "higan/out/higan.app", libexec
    mv "icarus/out/icarus.app", libexec
  end

  test do
    assert_predicate libexec/"higan.app", :exist?
    assert_predicate libexec/"icarus.app", :exist?
  end
end

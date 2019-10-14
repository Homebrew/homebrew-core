class FcitxRemoteForOsx < Formula
  desc "Handle input method in command-line"
  homepage "https://github.com/CodeFalling/fcitx-remote-for-osx"
  url "https://github.com/CodeFalling/fcitx-remote-for-osx/archive/0.3.0.tar.gz"
  sha256 "b4490a6a0db3c28ce3ddbe89dd038f5ab404744539adc5520eab1a1a39819de6"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "7e6f127565c5e0b1c842cf88ee440ac1e86d99a902c1f892008e146cfe86497a" => :catalina
    sha256 "63e285ce25dfefd7220ed07bb0c85f0b2f6e74997b0eb94117619cfdc04a5002" => :mojave
    sha256 "6c88cbd0c4ca46c2b0d809adc3e93c4be3178c014b55d377f95b7e0740cfab99" => :high_sierra
    sha256 "16efcc3f2a5ac6fd63bfea3d85286fac823cc7b21520d85f46d0b3c066668671" => :sierra
  end

  def install
    system "./build.py", "build", "general"
    bin.install "fcitx-remote-general"
    bin.install_symlink "fcitx-remote-general" => "fcitx-remote"
  end

  test do
    system "#{bin}/fcitx-remote", "-n"
  end
end

class FcitxRemoteForOsx < Formula
  desc "Handle input method in command-line"
  homepage "https://github.com/xcodebuild/fcitx-remote-for-osx"
  url "https://github.com/xcodebuild/fcitx-remote-for-osx/archive/0.3.0.tar.gz"
  sha256 "b4490a6a0db3c28ce3ddbe89dd038f5ab404744539adc5520eab1a1a39819de6"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce28a692f51a2441d407a19430c933720702367a504163979bb0345ae8cf9de8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "12913aa01bc77d930cef72d681c39e473cf5c1a5f412bf971d9eacefed65f586"
    sha256 cellar: :any_skip_relocation, monterey:       "e40e0497b894b54f53a448f159bfda1ce076c9730c81667e6e6cf409db5fd830"
    sha256 cellar: :any_skip_relocation, big_sur:        "118a6409c3a5fb1702d3f9c7fa91959d3b38e480da77a88b49a8f7c605a7ae46"
    sha256 cellar: :any_skip_relocation, catalina:       "7e6f127565c5e0b1c842cf88ee440ac1e86d99a902c1f892008e146cfe86497a"
    sha256 cellar: :any_skip_relocation, mojave:         "63e285ce25dfefd7220ed07bb0c85f0b2f6e74997b0eb94117619cfdc04a5002"
    sha256 cellar: :any_skip_relocation, high_sierra:    "6c88cbd0c4ca46c2b0d809adc3e93c4be3178c014b55d377f95b7e0740cfab99"
    sha256 cellar: :any_skip_relocation, sierra:         "16efcc3f2a5ac6fd63bfea3d85286fac823cc7b21520d85f46d0b3c066668671"
  end

  depends_on :macos

  def install
    system "./build.py", "build", "general"
    bin.install "fcitx-remote-general"
    bin.install_symlink "fcitx-remote-general" => "fcitx-remote"
  end

  test do
    system "#{bin}/fcitx-remote", "-n"
  end
end

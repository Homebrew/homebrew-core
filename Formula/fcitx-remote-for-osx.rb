class FcitxRemoteForOsx < Formula
  desc "Handle input method in command-line"
  homepage "https://github.com/CodeFalling/fcitx-remote-for-osx"
  url "https://github.com/CodeFalling/fcitx-remote-for-osx/archive/0.3.0.tar.gz"
  sha256 "b4490a6a0db3c28ce3ddbe89dd038f5ab404744539adc5520eab1a1a39819de6"

  bottle do
    cellar :any_skip_relocation
    sha256 "d0d5e296210ad94fb80bdc8e8058a2ad32ba293f3a1d9bb54ab2dd2de573e5f8" => :high_sierra
    sha256 "91611184e35f77a587eb1c36042660809564ff3fbae553d492b036a8b64b4f56" => :sierra
    sha256 "8e54fa21fce7e9e363dba2a47f462d1b415d55e9687322d251e2e5995442599a" => :el_capitan
  end

  option "with-input-method=", "Select input method: general(default), baidu-pinyin, baidu-wubi, sogou-pinyin, qq-wubi, squirrel-rime, squirrel-rime-upstream, osx-pinyin"

  def install
    input_method = ARGV.value("with-input-method") || "general"
    system "./build.py", "build", input_method
    bin.install "fcitx-remote-#{input_method}"
    bin.install_symlink "fcitx-remote-#{input_method}" => "fcitx-remote"
  end

  test do
    system "#{bin}/fcitx-remote", "-n"
  end
end

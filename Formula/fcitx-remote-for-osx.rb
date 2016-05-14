class FcitxRemoteForOsx < Formula
  desc "handle input method in command-line"
  homepage "https://github.com/CodeFalling/fcitx-remote-for-osx"
  url "https://github.com/CodeFalling/fcitx-remote-for-osx/archive/0.1.0.tar.gz"
  sha256 "0a4233175e7dfbaaa0ba308b54552503e814c001c6366f28cce7f9bcae3abebb"

  bottle do
    cellar :any_skip_relocation
    sha256 "cf7efa11cfe3c881508944be45d8e738457686fb4fdfe44aacee794c966130e3" => :el_capitan
    sha256 "e626aa6a38097d77b659f2fe00f336e472c6ccc11f4580260b5f683af783dc29" => :yosemite
    sha256 "1ef36e4590006d34b20c5beb8a428de5177a7f492dff8ade55e6e3346f1b2a6d" => :mavericks
  end

  option "with-input-method=", "Select input method: general(default), baidu-pinyin, baidu-wubi, sogou-pinyin, qq-wubi, squirrel-rime, osx-pinyin"

  def install
    input_method = ARGV.value("with-input-method") || "general"
    system "./build.py", "build", input_method
    bin.install "fcitx-remote-#{input_method}"
    bin.install_symlink "fcitx-remote-#{input_method}" => "fcitx-remote"
  end

  test do
    system "#{bin}/fcitx-remote"
  end
end

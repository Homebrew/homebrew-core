class FcitxRemoteForOsx < Formula
  desc "Handle input method in command-line"
  homepage "https://github.com/CodeFalling/fcitx-remote-for-osx"
  url "https://github.com/CodeFalling/fcitx-remote-for-osx/archive/0.3.0.tar.gz"
  sha256 "b4490a6a0db3c28ce3ddbe89dd038f5ab404744539adc5520eab1a1a39819de6"

  bottle do
    cellar :any_skip_relocation
    sha256 "23ca3b8325b509ccf9991009a7d34e3afff5a4a2f12d054d0034dc950ada1f05" => :high_sierra
    sha256 "138ca03de1639465bb99bdac40a33fc57d21a53c53b25791493c8cbbd6675eab" => :sierra
    sha256 "5dd74e46ad011a623dedf189e7e63c7ae5b037e60f728b5aac9389bf20628d63" => :el_capitan
    sha256 "1a400d131adec21aea258c11c83038ac72ee6fe6cd0bc237af0f3238d5459984" => :yosemite
    sha256 "7e64b4eb71352b65cb227017068c2a9ec22708a9ca612228cfafd8208b3e1fe9" => :mavericks
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

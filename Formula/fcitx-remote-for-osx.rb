class FcitxRemoteForOsx < Formula
  desc "handle input method in command-line"
  homepage "https://github.com/CodeFalling/fcitx-remote-for-osx"
  url "https://github.com/CodeFalling/fcitx-remote-for-osx/archive/0.2.0.tar.gz"
  sha256 "6b641f692e96d1da741780d46941e8ab1d59ca7ea8909458888f20dea628b481"

  bottle do
    cellar :any_skip_relocation
    sha256 "138ca03de1639465bb99bdac40a33fc57d21a53c53b25791493c8cbbd6675eab" => :sierra
    sha256 "5dd74e46ad011a623dedf189e7e63c7ae5b037e60f728b5aac9389bf20628d63" => :el_capitan
    sha256 "1a400d131adec21aea258c11c83038ac72ee6fe6cd0bc237af0f3238d5459984" => :yosemite
    sha256 "7e64b4eb71352b65cb227017068c2a9ec22708a9ca612228cfafd8208b3e1fe9" => :mavericks
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

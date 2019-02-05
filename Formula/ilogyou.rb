class Ilogyou < Formula
  desc "Swift Framework for membership handling"
  homepage "https://github.com/leolgrn/iLogYou/"
  url "https://github.com/leolgrn/iLogYou/releases/download/iLogYou/iLogYou.tar.gz"
  version "1.0.0"
  sha256 "3f12b57f7cadd25666ca528ab4f8cfd60fbeb51b6d2b0c0a69037e990aeee5f4"

  def install
    bin.install "iLogYou"
  end
end

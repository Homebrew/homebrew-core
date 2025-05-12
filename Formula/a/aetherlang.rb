class Aetherlang < Formula
  desc "A cloud-native programming language"
  homepage "https://github.com/iamvirul/Aetherlang"
  version "1.1.0"
  license "MIT"

  url "https://github.com/iamvirul/Aetherlang/releases/download/v1.1.0/aeth"
  sha256 "572b1cf8e9a0b9c6b8f6fe4d111ca7ee23c6e7439df4e0d216b813531a876e1b"

  resource "aethc" do
    url "https://github.com/iamvirul/Aetherlang/releases/download/v1.1.0/aethc"
    sha256 "7e860aa6fcee54fd54be7269b2e32fc45d91541efdc5253036d9d603f68bddcd"
  end

  def install
    bin.install "aeth"
    resource("aethc").stage { bin.install "aethc" }
  end

  test do
    system "#{bin}/aeth", "--version"
  end
end
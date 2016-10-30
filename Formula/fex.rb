class Fex < Formula
  desc "Powerful field extraction tool"
  homepage "https://www.semicomplete.com/projects/fex/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/semicomplete/fex-2.0.0.tar.gz"
  sha256 "03043c8eac74f43173068a2e693b6f73d5b45f453a063e6da11f34455d0e374e"

  bottle do
    cellar :any_skip_relocation
    sha256 "e42328824017f1432ace562fdd70061e504c5524d2702f3d4b470c40b1bf105e" => :sierra
    sha256 "952c166ae7efc5c7955bba3c54fefc1e5c18fe2296804b15554a8703285034e1" => :el_capitan
    sha256 "2c20c6bf653b60b290d6e08aee9aaa46475754cfd61680e312d46678ea9a1f4c" => :yosemite
    sha256 "1fc2bf94e26daa8dd17b1e1f614b8fdffabac6665b7eb38a659e4e3dee5772ae" => :mavericks
    sha256 "16702c82f31fa869a73b58e5fb91620dc4b51d09352b919b55e0fbdb6d15f468" => :mountain_lion
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_equal "foo", pipe_output("#{bin}/fex 1", "foo bar", 0).chomp
  end
end

class Bagoup < Formula
  desc "Mac OS Messages export"
  homepage "https://github.com/tagatac/bagoup"
  url "https://github.com/tagatac/bagoup/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "30107e5e9d8c3e67ac21fc7219a7cb4b95f20f96da35074fe718994b565ba177"
  license "AGPL-3.0-or-later"

  depends_on "go" => :build
  depends_on "make" => :build
  depends_on :macos
  depends_on "weasyprint"

  def install
    system "make", "from-archive"
    mkdir bin.to_s
    cp "bin/typedstream-decode", bin/"typedstream-decode"
    cp "bin/bagoup", bin/"bagoup"
  end

  test do
    assert_equal "Usage:\n  bagoup [OPTIONS]\n", shell_output("#{bin}/bagoup --help | head -n 2")
  end
end

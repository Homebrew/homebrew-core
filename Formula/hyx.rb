class Hyx < Formula
  desc "Powerful hex editor for the console"
  homepage "https://yx7.cc/code/"
  url "https://yx7.cc/code/hyx/hyx-2021.06.09.tar.xz"
  sha256 "8d4f14e58584d6cc8f04e43ca38042eed218882a389249c20b086730256da5eb"
  license "MIT"

  depends_on "expect" => :test

  def install
    ENV["CFLAGS"] = "-Os"
    system "make"

    bin.install "hyx"
    doc.install "license.txt"
  end

  test do
    assert_match(/window|0000/,
      pipe_output("env TERM=tty expect -",
                  "spawn #{bin}/hyx;send \"q\";expect eof"))
  end
end

class Entr < Formula
  desc "Run arbitrary commands when files change"
  homepage "https://eradman.com/entrproject/"
  url "https://eradman.com/entrproject/code/entr-4.9.tar.gz"
  sha256 "e256a4d2fbe46f6132460833ba447e65d7f35ba9d0b265e7c4150397cc4405a2"
  license "ISC"
  head "https://github.com/eradman/entr.git"

  livecheck do
    url "https://eradman.com/entrproject/code/"
    regex(/href=.*?entr[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6ea2876fa3470d9959ab4da944f3ea50135f998531056a5254b66e5555435b77"
    sha256 cellar: :any_skip_relocation, big_sur:       "2cd27734479f6797b4d935d434f795a9794acd6e6dab0f0215b4ac96384c75ae"
    sha256 cellar: :any_skip_relocation, catalina:      "9e8c9239cf071087ff47cfcd1ab0a729a77e5a9e7284a038d1790a81eebd70a3"
    sha256 cellar: :any_skip_relocation, mojave:        "810b1d21eef7e39c5194296c0717bdb200c2d5f1edf2c64d24093d4df95d4bf2"
  end

  def install
    ENV["PREFIX"] = prefix
    ENV["MANPREFIX"] = man
    system "./configure"
    system "make"
    system "make", "install"
  end

  test do
    touch testpath/"test.1"
    fork do
      sleep 0.5
      touch testpath/"test.2"
    end
    assert_equal "New File", pipe_output("#{bin}/entr -n -p -d echo 'New File'", testpath).strip
  end
end

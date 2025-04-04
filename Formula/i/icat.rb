class Icat < Formula
  desc "Outputs images in 256-color capable terminals"
  homepage "https://github.com/atextor/icat"
  url "https://github.com/atextor/icat/archive/refs/tags/v0.5.tar.gz"
  sha256 "1d77f20c7eab29efe22aeebe426301b7dca1f898759c63f32a714c7c9ae1aab4"
  license "BSD-2-Clause"

  depends_on "imlib2"

  def install
    system "make"
    bin.install "icat"
    man1.install "icat.man" => "icat.1"
  end

  test do
    assert_equal "\e[0m\e[38;5;9m▀\e[0m\n", shell_output("#{bin}/icat #{test_fixtures("test.jpg")}")
  end
end

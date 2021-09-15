class Jpegrescan < Formula
  desc "Losslessly shrink any JPEG file"
  homepage "https://github.com/kud/jpegrescan"
  url "https://github.com/kud/jpegrescan/archive/1.1.0.tar.gz"
  sha256 "a8522e971d11c904f4b61af665c3be800f26404e2b14f5f80c675b4a72a42b32"
  head "https://github.com/kud/jpegrescan.git"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a09a6149fe87f3cc7a2f54b9b3c538bc6881d3b4e7edc6f947ed54d29d4ad473"
  end

  depends_on "jpeg"

  def install
    bin.install "jpegrescan"
  end

  test do
    system bin/"jpegrescan", "-v", test_fixtures("test.jpg"), testpath/"out.jpg"
    assert_predicate testpath/"out.jpg", :exist?
  end
end

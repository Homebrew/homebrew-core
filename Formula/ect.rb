class Ect < Formula
  desc "File and image optimizer. It supports PNG, JPEG, GZIP and ZIP files."
  homepage "https://github.com/fhanau/Efficient-Compression-Tool#readme"
  url "https://github.com/fhanau/Efficient-Compression-Tool/archive/0.7.tar.gz"
  sha256 "e117bc274e91de38eee11fef89e65c397962ffb9d500851061d9745924e77cd1"
  head "https://github.com/fhanau/Efficient-Compression-Tool.git"

  depends_on "nasm" => :build

  def install
    ENV.deparallelize
    cd "src" do
      system "make"
    end

    bin.install "ECT"
  end

  test do
    system "#{bin}/ECT", test_fixtures("test.png")
  end
end

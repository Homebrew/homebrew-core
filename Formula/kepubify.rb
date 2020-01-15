class Kepubify < Formula
  desc "Convert ebooks from epub to kepub"
  homepage "https://pgaskin.net/kepubify/"
  url "https://github.com/geek1011/kepubify/archive/v2.5.1.tar.gz"
  sha256 "880c9438d0fd9e5812deb1e493394e9766c8ff0bcf582b63a9a5d085b8c993e7"
  head "https://github.com/geek1011/kepubify.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "dacfe22fc6a6c5ebfcb03034bf5fbbf0fa56aeff8be1f59c18eb2ab3e415f64b" => :catalina
    sha256 "e69e7ef5cc5c56eac22bb89c81f9c25c7b28dd857f611f50eebdae04bd47e147" => :mojave
    sha256 "ce03624c0513107362bce74ceb3c34b9f426ab201a3123a43d4b18b52a947395" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = HOMEBREW_CACHE/"go_cache"

    ldflags = "-s -w -X main.version=#{version}"

    system "go", "build", "-o", bin/"kepubify",
                 "-ldflags", ldflags

    system "go", "build", "-o", bin/"covergen",
                 "-ldflags", ldflags, "./covergen"

    system "go", "build", "-o", bin/"seriesmeta",
                 "-ldflags", ldflags, "./seriesmeta"

    pkgshare.install "kepub/testdata/books/test1.epub"
  end

  test do
    pdf = test_fixtures("test.pdf")
    output = shell_output("#{bin}/kepubify #{pdf} 2>&1", 1)
    assert_match "not an epub", output

    system bin/"kepubify", pkgshare/"test1.epub"
    assert_predicate testpath/"test1.kepub.epub", :exist?
  end
end

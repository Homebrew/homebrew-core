class Kepubify < Formula
  desc "Convert ebooks from epub to kepub"
  homepage "https://pgaskin.net/kepubify/"
  url "https://github.com/geek1011/kepubify/archive/v2.3.3.tar.gz"
  sha256 "57bbd5c5f24eab4d5eb5ab2dd9fb7b534afbfaf78d0c07fbf8c570b2fe5fae0a"
  head "https://github.com/geek1011/kepubify.git"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = HOMEBREW_CACHE/"go_cache"

    system "go", "build", "-o", bin/"kepubify",
                 "-ldflags", "-X main.version=v#{version}"

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

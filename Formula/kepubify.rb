class Kepubify < Formula
  desc "Convert ebooks from epub to kepub"
  homepage "https://pgaskin.net/kepubify/"
  url "https://github.com/geek1011/kepubify/archive/v2.5.0.tar.gz"
  sha256 "35ab862eebd8047d183c5dce53373c8cd8380d4e8742ba4749eb64a8771c84c8"
  head "https://github.com/geek1011/kepubify.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "401be729baa7fc2f9bb829269f1ee04494a17c3bcbb22f51ce6fa22de5689b0c" => :catalina
    sha256 "c12e0cc0d0d83a815475bd3c1abf0639f719b6f2736ec03adb60663bf07edc40" => :mojave
    sha256 "54fba93cf355c8a1ef099dca00219eefa171bfe0b6efa93a95e24490ec420541" => :high_sierra
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

class Goreman < Formula
  desc "Foreman clone written in Go"
  homepage "https://github.com/mattn/goreman"
  url "https://github.com/mattn/goreman/archive/v0.3.0.tar.gz"
  sha256 "80b439dc2d68e59003c5cb1739a8c2241be54ece36e8cb686e4db25bee9e141a"

  bottle do
    cellar :any_skip_relocation
    sha256 "05f671ec06b1bdb69d7ae497026fb9e7d892ff30d176fbd85a7b1f96576f2938" => :catalina
    sha256 "896a22c18d18985195df7b47f655b759051856a12406f4de23e3a511630eadee" => :mojave
    sha256 "f3ea945f4596a6f2b218c1fea6ff2e9e7fc4420b07b1f32a22698c01e5a59424" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    srcpath = buildpath/"src/github.com/mattn/goreman"
    srcpath.install buildpath.children

    cd srcpath do
      system "go", "build", "-o", bin/"goreman"
      prefix.install_metafiles
    end
  end

  test do
    (testpath/"Procfile").write "web: echo 'hello' > goreman-homebrew-test.out"
    system bin/"goreman", "start"
    assert_predicate testpath/"goreman-homebrew-test.out", :exist?
    assert_match "hello", (testpath/"goreman-homebrew-test.out").read
  end
end

class Kepubify < Formula
  desc "Convert ebooks from epub to kepub"
  homepage "https://pgaskin.net/kepubify/"
  url "https://github.com/geek1011/kepubify/archive/v3.1.2.tar.gz"
  sha256 "69f02af0846eb5c153db73a1c07b53ba478986ca07f87af400d66e5f47699f81"
  license "MIT"
  head "https://github.com/geek1011/kepubify.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "03a69105b70a3d021fd013f5883dca27b78d367c53f4c022d97837b6a21a6875" => :catalina
    sha256 "b320420bf7ba3e05fa4cfa5c9df55e27bc086836d582fdf726bd3c569b196384" => :mojave
    sha256 "38eb6db2a92942233f877ed25b65db4292e7cc65e0c28af32edd867e313fcb82" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = HOMEBREW_CACHE/"go_cache"

    %w[
      kepubify
      covergen
      seriesmeta
    ].each do |p|
      system "go", "build", "-o", bin/p,
                   "-ldflags", "-s -w -X main.version=#{version}",
                   "./cmd/#{p}"
    end

    pkgshare.install "kepub/test.epub"
  end

  test do
    pdf = test_fixtures("test.pdf")
    output = shell_output("#{bin}/kepubify #{pdf} 2>&1", 1)
    assert_match "Error: invalid extension", output

    system bin/"kepubify", pkgshare/"test.epub"
    assert_predicate testpath/"test_converted.kepub.epub", :exist?
  end
end

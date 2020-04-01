class Kepubify < Formula
  desc "Convert ebooks from epub to kepub"
  homepage "https://pgaskin.net/kepubify/"
  url "https://github.com/geek1011/kepubify/archive/v3.1.2.tar.gz"
  sha256 "69f02af0846eb5c153db73a1c07b53ba478986ca07f87af400d66e5f47699f81"
  head "https://github.com/geek1011/kepubify.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4354d7623d0cb61775d45d8d06b1cdf990ffc3d0719d894bb275b6b760b91d0c" => :catalina
    sha256 "55cab7e4b6847c8a0301416b41e2e24f1a9ec1bf532e642d61f92ff86df581ad" => :mojave
    sha256 "3a9e181d2e5c4b382950443be49d096ed0257cf9d697c6177060d9d5086967fa" => :high_sierra
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

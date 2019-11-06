class K6 < Formula
  desc "Modern load testing tool, using Go and JavaScript"
  homepage "https://k6.io"
  url "https://github.com/loadimpact/k6.git",
    :tag      => "v0.25.1",
    :revision => "515452f1a93a271ed8a3785111726c7cfe92232d"

  bottle do
    cellar :any_skip_relocation
    sha256 "e6a4f10a33ce1f4c5860643afcd1a3a5a1c23bb4f481c59d02bbd4f7a41836de" => :catalina
    sha256 "a06505e1d2e7cc083acc511d6f1d9d710186561d9ae8a7dbf884b3a62f649ae4" => :mojave
    sha256 "47718cefff5ce85d27e09914590b26c13f4a37d26096f971e0cff059cd74166e" => :high_sierra
    sha256 "d88317a09fddc7343bfedc774decd5b679284298bcf37dac0f3372e76e429c38" => :sierra
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    dir = buildpath/"src/github.com/loadimpact/k6"
    dir.install buildpath.children

    cd dir do
      system "dep", "ensure", "-vendor-only"
      system "go", "build", "-o", bin/"k6"
      prefix.install_metafiles
    end
  end

  test do
    output = "Test finished"
    assert_match output, shell_output("#{bin}/k6 run github.com/loadimpact/k6/samples/http_get.js 2>&1")
    assert_match version.to_s, shell_output("#{bin}/k6 version")
  end
end

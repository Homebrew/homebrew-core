class CollectorSidecar < Formula
  desc "Manage log collectors through Graylog"
  homepage "https://github.com/Graylog2/collector-sidecar"
  url "https://github.com/Graylog2/collector-sidecar/archive/0.1.2.tar.gz"
  sha256 "e551ab2254ff6985584298079b1d00f11b6488c0d9b23864a1f4e3c51d1cfe58"

  bottle do
    sha256 "a9aaafbc4ed7ac7b8f94e320757702cf38a91e889e721bbe576fecb860747d75" => :sierra
    sha256 "378b416968e1ec9320670213ff0e11833b2f1b2f7f9fe842338ea2de73d8f1de" => :el_capitan
    sha256 "889b43fa8159c46c3631e1ab05a5ad50963d1e6ff24b95235f15353b568f6c95" => :yosemite
  end

  depends_on "glide" => :build
  depends_on "go" => :build
  depends_on :hg => :build
  depends_on "filebeat" => :run

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"
    (buildpath/"src/github.com/Graylog2/collector-sidecar").install buildpath.children
    cd "src/github.com/Graylog2/collector-sidecar" do
      inreplace "main.go", "/etc", etc
      inreplace "collector_sidecar.yml", "/usr", HOMEBREW_PREFIX
      inreplace "collector_sidecar.yml", "/etc", etc
      inreplace "collector_sidecar.yml", "/var", var
      system "glide", "install"
      system "make", "build"
      (etc/"graylog/collector-sidecar").install "collector_sidecar.yml"
      bin.install "graylog-collector-sidecar"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/graylog-collector-sidecar -version")
  end
end

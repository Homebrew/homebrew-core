class CollectorSidecar < Formula
  desc "Manage log collectors through Graylog"
  homepage "https://github.com/Graylog2/collector-sidecar"
  url "https://github.com/Graylog2/collector-sidecar/archive/0.1.1.tar.gz"
  sha256 "c71f9762a74e10827d9f671b31d826d63fb9b35e5c3230a361b65edfcfc02ff7"

  bottle do
    sha256 "349f1d29a4cc9aca04183d3d3377b2545f013fc7f8ab33addb8d2c9953eab29d" => :sierra
    sha256 "a9f98ffbe8dcec5067b79c93a105fe838ee2ee82c29d77fec5497dd0d1860631" => :el_capitan
    sha256 "26168651f47c4af792ffc288e2d4ae30587bde5e696194008aa6295ecdf3b19d" => :yosemite
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

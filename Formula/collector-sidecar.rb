class CollectorSidecar < Formula
  desc "Manage log collectors through Graylog"
  homepage "https://github.com/Graylog2/collector-sidecar"
  url "https://github.com/Graylog2/collector-sidecar/archive/0.1.1.tar.gz"
  sha256 "c71f9762a74e10827d9f671b31d826d63fb9b35e5c3230a361b65edfcfc02ff7"

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

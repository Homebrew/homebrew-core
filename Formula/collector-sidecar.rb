class CollectorSidecar < Formula
  desc "Manage log collectors through Graylog"
  homepage "https://github.com/Graylog2/collector-sidecar"
  url "https://github.com/Graylog2/collector-sidecar/archive/0.1.3.tar.gz"
  sha256 "96bae250e12d2ab17c563feacba4367e4089f72e54048eec8462584d49f2440f"

  bottle do
    sha256 "2f66645d9fabf955937241e1c45c0a5a1ebe9aadf9c067da03d32354a9e4d2ce" => :sierra
    sha256 "2101d71785925194a0fe73f20e066afa67f3e5a658ff9d8a665004fe48714c03" => :el_capitan
    sha256 "76c42c8199bae3d7c552753946ee991f33c0c48365e937a1ac85ebde4807d3c9" => :yosemite
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

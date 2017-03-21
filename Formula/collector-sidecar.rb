class CollectorSidecar < Formula
  desc "Manage log collectors through Graylog"
  homepage "https://github.com/Graylog2/collector-sidecar"
  url "https://github.com/Graylog2/collector-sidecar/archive/0.1.0.tar.gz"
  sha256 "32cc77886ef7b8e26167c1d88f77d02e9c39f41db333031b0ae14537f398e5fd"

  bottle do
    sha256 "58e3e43fa357b6518cfa74bb82e506df272eedfadfb2dedf195d0b5f1569753f" => :sierra
    sha256 "9ba341ae108239340acc6901aeda8edd3fa63eb0e42daeec3d866f09dcc5db73" => :el_capitan
    sha256 "07d2094756dd3c5922b9fab7f04008bbdd8a7408f5b3d9cbcb8e2ddc7cf99b1d" => :yosemite
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

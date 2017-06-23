class CollectorSidecar < Formula
  desc "Manage log collectors through Graylog"
  homepage "https://github.com/Graylog2/collector-sidecar"
  url "https://github.com/Graylog2/collector-sidecar/archive/0.1.2.tar.gz"
  sha256 "e551ab2254ff6985584298079b1d00f11b6488c0d9b23864a1f4e3c51d1cfe58"

  bottle do
    sha256 "3aabb1cfdcbc5f75943f9dca321041c30c9e4780c0c705c5f2aa7d99dc61b440" => :sierra
    sha256 "13deca1abfdb172279e944281257ad5ecc7a0249d7b6f420748070771f7f279d" => :el_capitan
    sha256 "7f0c882ea42c401cb0228b1801c22b98184b03b17785ef873e13806cec5d7a49" => :yosemite
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

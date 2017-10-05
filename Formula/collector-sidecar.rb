class CollectorSidecar < Formula
  desc "Manage log collectors through Graylog"
  homepage "https://github.com/Graylog2/collector-sidecar"
  url "https://github.com/Graylog2/collector-sidecar/archive/0.1.4.tar.gz"
  sha256 "3d73f8054a52411ff6d71634bc93b23a55372477069fcfad699876f82ae22ce8"

  bottle do
    sha256 "f0b0a86af0fa4a9f01fa42a4112484bb1057a236407b56c0b05e32ca0f52a632" => :high_sierra
    sha256 "a570422eab63c9476cbbf127fc878a1410fa0ac7ff44bbe55227df73fbba0713" => :sierra
    sha256 "3db2950f3b53860ffb1a7b98e0f87adb45d106c2c5070d4b2ef7cfbd9662be05" => :el_capitan
    sha256 "d8f11c6167e2b3d66f4e67e7d7e2e4d013a71cd3b591e37da21fe809abf21e01" => :yosemite
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

      inreplace "collector_sidecar.yml" do |s|
        s.gsub! "/usr", HOMEBREW_PREFIX
        s.gsub! "/etc", etc
        s.gsub! "/var", var
      end

      system "glide", "install"
      system "make", "build"
      (etc/"graylog/collector-sidecar").install "collector_sidecar.yml"
      bin.install "graylog-collector-sidecar"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/graylog-collector-sidecar -version")
  end
end

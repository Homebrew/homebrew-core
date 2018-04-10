class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://github.com/istio/fortio"
  url "https://github.com/istio/fortio.git",
      :using => :git,
      :tag => "v0.9.0",
      :revision => "e50943e8e525197f36f9b4f81464615c063a0a65"
  head "https://github.com/istio/fortio.git"

  depends_on "go" => :build

  def install
    ENV["XC_OS"] = "darwin"
    ENV["XC_ARCH"] = MacOS.prefer_64_bit? ? "amd64" : "386"
    ENV["GOPATH"] = buildpath
    ENV["CGO_ENABLED"] = "0"
    contents = Dir["{*,.git,.gitignore}"]
    (buildpath/"src/istio.io/fortio").install contents
    cd "src/istio.io/fortio" do
      date = `date +"%Y-%m-%d %H:%M"`.strip
      rev = `git rev-parse HEAD`.strip
      build_info = "#{date} #{rev}"
      tag = `git describe --tags --match "v*"`.strip
      link_flags = "-s -X istio.io/fortio/ui.resourcesDir=#{lib} "\
        "-X istio.io/fortio/version.tag=#{tag} "\
        "-X \"istio.io/fortio/version.buildInfo=#{build_info}\""
      system "go", "build", "-a", "-ldflags", link_flags.to_s
      bin.install "fortio"
      lib.install Dir["ui/static", "ui/templates"]
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fortio --version")
  end
end

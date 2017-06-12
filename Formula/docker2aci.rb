class Docker2aci < Formula
  desc "Library and CLI tool to convert Docker images to ACIs"
  homepage "https://github.com/appc/docker2aci"
  url "https://github.com/appc/docker2aci/archive/v0.16.0.tar.gz"
  sha256 "7a8abe8b809a0dcf7a583c6a8ba8232eedb97d30750fa4b4f0620e9db6e504fb"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/appc").mkpath
    ln_s buildpath, buildpath/"src/github.com/appc/docker2aci"
    system "go", "build", "-o", bin/"docker2aci", "-ldflags",
      "-X github.com/appc/docker2aci/lib.Version=#{version}",
      "github.com/appc/docker2aci"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/docker2aci -version")
    system "#{bin}/docker2aci", "docker://busybox"
  end
end

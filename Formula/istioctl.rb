class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://github.com/istio/istio"
  url "https://github.com/istio/istio.git",
      :tag      => "1.5.2",
      :revision => "68d381dde45b34f82a7247f20840829f1ee56fc1"

  bottle do
    cellar :any_skip_relocation
    sha256 "614b3333aa28d767fdc3b50226c0a7f059b2eb4b9b7ea832008f8df54f34eab9" => :catalina
    sha256 "a812d92615ab47160842ec7a688eb108210fa2b956ea5407354262998cc72530" => :mojave
    sha256 "a812d92615ab47160842ec7a688eb108210fa2b956ea5407354262998cc72530" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["TAG"] = version.to_s
    ENV["ISTIO_VERSION"] = version.to_s
    ENV["HUB"] = "docker.io/istio"

    srcpath = buildpath/"src/istio.io/istio"
    outpath = srcpath/"out/darwin_amd64"
    srcpath.install buildpath.children

    cd srcpath do
      system "make", "istioctl", "istioctl.completion"
      prefix.install_metafiles
      bin.install outpath/"istioctl"
      bash_completion.install outpath/"release/istioctl.bash"
      zsh_completion.install outpath/"release/_istioctl"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/istioctl version --remote=false")
  end
end

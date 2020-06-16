class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://github.com/istio/istio"
  url "https://github.com/istio/istio.git",
      :tag      => "1.6.2",
      :revision => "70f86ede30e826dd18542e95d856255e9780a24f"

  bottle do
    cellar :any_skip_relocation
    sha256 "e2fa03231877875b91a44d93f2e6a7ddfe660bed5228b6e4168784b6ede056bf" => :catalina
    sha256 "e2fa03231877875b91a44d93f2e6a7ddfe660bed5228b6e4168784b6ede056bf" => :mojave
    sha256 "e2fa03231877875b91a44d93f2e6a7ddfe660bed5228b6e4168784b6ede056bf" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["TAG"] = version.to_s
    ENV["ISTIO_VERSION"] = version.to_s
    ENV["HUB"] = "docker.io/istio"
    ENV["BUILD_WITH_CONTAINER"] = "0"

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

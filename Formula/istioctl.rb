class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://github.com/istio/istio"
  url "https://github.com/istio/istio.git",
      :tag      => "1.6.4",
      :revision => "58f551e08f08addfd81783e1c2ed1eabeb836168"

  bottle do
    cellar :any_skip_relocation
    sha256 "c4ee60917aa4016dcf01df38ac018bd86634a0c3a5986c14808dbc4091c65529" => :catalina
    sha256 "c4ee60917aa4016dcf01df38ac018bd86634a0c3a5986c14808dbc4091c65529" => :mojave
    sha256 "c4ee60917aa4016dcf01df38ac018bd86634a0c3a5986c14808dbc4091c65529" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build

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
      system "make", "gen-charts", "istioctl", "istioctl.completion"
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

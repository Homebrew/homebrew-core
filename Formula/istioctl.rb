class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://github.com/istio/istio"
  url "https://github.com/istio/istio.git",
      :tag      => "1.4.5",
      :revision => "f7b065dac2aee3db82630727c14b8ffdfb5a2713"

  bottle do
    cellar :any_skip_relocation
    sha256 "dcdb7cd7cf4906be4a43271ac6e5f339f633fa48fe38c7f61a054df22205bbd0" => :catalina
    sha256 "dcdb7cd7cf4906be4a43271ac6e5f339f633fa48fe38c7f61a054df22205bbd0" => :mojave
    sha256 "dcdb7cd7cf4906be4a43271ac6e5f339f633fa48fe38c7f61a054df22205bbd0" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["TAG"] = version.to_s
    ENV["ISTIO_VERSION"] = version.to_s
    ENV["HUB"] = "docker.io/istio"

    srcpath = buildpath/"src/istio.io/istio"
    outpath = buildpath/"out/darwin_amd64/release"
    srcpath.install buildpath.children

    cd srcpath do
      system "make", "istioctl"
      prefix.install_metafiles
      bin.install outpath/"istioctl"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/istioctl version --remote=false")
  end
end

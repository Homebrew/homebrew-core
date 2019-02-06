class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://github.com/istio/istio"
  url "https://github.com/istio/istio.git",
      :tag      => "1.0.5",
      :revision => "c1707e45e71c75d74bf3a5dec8c7086f32f32fad"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "2e334e39d308647749f47f59e7c4f5eac3fab4a61879a612f85de2d383ab645b" => :mojave
    sha256 "2b9d133101fea74b0e03ee2387b113a4f894a2674b8ad874e0d76708726032d0" => :high_sierra
    sha256 "369afc88ef289438d12b9c105058d77a3e281b44e9e0e8a99d9d1c5fda722a0c" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["TAG"] = version.to_s
    ENV["ISTIO_VERSION"] = version.to_s

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
    assert_match "Retrieve policies and rules", shell_output("#{bin}/istioctl get -h")
  end
end

class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://github.com/istio/istio"
  url "https://github.com/istio/istio.git",
      :tag      => "1.2.2",
      :revision => "cd4a148f37dc386986d6a6d899778849e686beea"

  bottle do
    cellar :any_skip_relocation
    sha256 "a22c0b1940f87fce7f6f68637f047392f621d2fdfdac86107d2aa012b85ce96f" => :mojave
    sha256 "890f09e0d2f7ba73eeb5557face0691fab1c916082373f3fe0f4801b90de9ea7" => :high_sierra
    sha256 "07b42a7d9e0c97094de4fd86c151a060380ef22853ce0b20593e57d8dac33e8f" => :sierra
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

class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://github.com/istio/istio"
  url "https://github.com/istio/istio.git",
      :tag      => "1.3.4",
      :revision => "bcdf2483e7911f63a8edd6706f08674f8b5805f3"

  bottle do
    cellar :any_skip_relocation
    sha256 "dd5cbd01bb98cdceb3b9cfc3cb95d84a0036fec2174d6c2464c0197b92b4e249" => :catalina
    sha256 "0eb2938687e307fd14b088580a64e2054d16d18d9ae6f54ca4f4f6c12186c3e6" => :mojave
    sha256 "57290c24da9fa63659b039ee38e4175576fbc9617f8d15483edb65550ce023d5" => :high_sierra
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

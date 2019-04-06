class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://github.com/istio/istio"
  url "https://github.com/istio/istio.git",
      :tag      => "1.1.2",
      :revision => "2b1331886076df103179e3da5dc9077fed59c989"

  bottle do
    cellar :any_skip_relocation
    sha256 "e63028e85946edd2715b65989b60f31066ce253da1d7039c3b9ccbbabd4756e9" => :mojave
    sha256 "3a97122622990694f0af2935aff3ba43f57660434eba65636743c80a6797f2f9" => :high_sierra
    sha256 "22a7b2f7aba50fc756f5f5fc60fc153a96d805af1f77046074e67c0591c35509" => :sierra
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

class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://github.com/istio/istio"
  url "https://github.com/istio/istio.git",
      :tag      => "1.1.1",
      :revision => "2b1331886076df103179e3da5dc9077fed59c989"

  bottle do
    cellar :any_skip_relocation
    sha256 "3ec928bca8b977e31bd5865e28c9ada90da0f88a0493f66e930e8db6106d7a96" => :mojave
    sha256 "43ea60a62a91354b1fafda8972fcfee55cfc55ef130f8f0beff5e5cb43da997f" => :high_sierra
    sha256 "14a7af91c674a63864afdc1936b8106068f5fadbc54c698ae85e09d8460a538c" => :sierra
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

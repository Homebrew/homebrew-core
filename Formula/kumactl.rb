class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://github.com/Kong/kuma/archive/0.5.1.tar.gz"
  sha256 "110589c3db3e744000c35d6c5f93a75e32861c871a8dafe8a74cfd1acc5145d3"

  bottle do
    cellar :any_skip_relocation
    sha256 "8761354c731ef8eb947e5509b381183eaf7baded8a912932b9baaa6d0c0955fe" => :catalina
    sha256 "b1f36efde9ee7fe353029bc7ab536caad2dd3842ebdb441024a26540d76c67be" => :mojave
    sha256 "be0577a06acdc4b2f5acbea3602f72b1a7ec4ac0d41744e1e4101ff9a526d671" => :high_sierra
  end

  depends_on "go" => :build

  def install
    srcpath = buildpath/"src/kuma.io/kuma"
    outpath = srcpath/"build/artifacts-darwin-amd64/kumactl"
    srcpath.install buildpath.children

    cd srcpath do
      system "make", "build/kumactl", "BUILD_INFO_VERSION=#{version}"
      prefix.install_metafiles
      bin.install outpath/"kumactl"
    end
  end

  test do
    assert_match "Management tool for Kuma.", shell_output("#{bin}/kumactl")
    assert_match version.to_s, shell_output("#{bin}/kumactl version 2>&1")

    touch testpath/"config"
    assert_match "Error: YAML contains invalid resource: Name field cannot be empty",
    shell_output("#{bin}/kumactl apply -f config 2>&1", 1)
  end
end

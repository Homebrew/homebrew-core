class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://github.com/Kong/kuma/archive/0.5.1.tar.gz"
  sha256 "110589c3db3e744000c35d6c5f93a75e32861c871a8dafe8a74cfd1acc5145d3"

  bottle do
    cellar :any_skip_relocation
    sha256 "a70f728d9658c016ad600d77082f87e0b765c926983b2062caa26cecd2522121" => :catalina
    sha256 "9e3367de422712aaa6edd06d55ba32df5bb62ea568d634a9d484f8847d972676" => :mojave
    sha256 "3411ece1648746fe532a51ab5f6747404a6b5eecd0f0fd136acb0d23dba28edb" => :high_sierra
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

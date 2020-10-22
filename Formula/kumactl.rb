class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://github.com/kumahq/kuma/archive/0.7.3.tar.gz"
  sha256 "d9f4392706557234fe2579285a3c1781d47239cfb05a71ab241bcc685d923627"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "a31a7af43e38e06da70e6c84f852521a96c87808177e8bf532c20e03117b4966" => :catalina
    sha256 "da9bff93f1ee754b513e066367502001053daa9cacfbcd80dbcd60b54a174a27" => :mojave
    sha256 "28cb6a7dfc8c68654c20bc35d9fd8d99d2e88523d2eab7f3680e01e558ad3a87" => :high_sierra
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

    (testpath/"config.yml").write <<~EOS
      name:
    EOS
    assert_match "Error: YAML contains invalid resource: Name field cannot be empty",
    shell_output("#{bin}/kumactl apply -f config.yml 2>&1", 1)
  end
end

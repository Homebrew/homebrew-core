class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://github.com/kumahq/kuma/archive/0.7.3.tar.gz"
  sha256 "d9f4392706557234fe2579285a3c1781d47239cfb05a71ab241bcc685d923627"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "2f2df9a3540a2c979e90b133339dacf0784fec0c6eb3ff4a062984ca94b4d411" => :catalina
    sha256 "0f6bab72b32fa986aeba183075fd3e43ca8afa2c3f92c324ea77dc7b91ebe103" => :mojave
    sha256 "e029d1b060e7a03ea3f6234e0ee7e2749c1ed3fd8da48aca7c706739f4117cdf" => :high_sierra
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

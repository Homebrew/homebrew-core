class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://github.com/kumahq/kuma/archive/0.7.1.tar.gz"
  sha256 "3daf41ae44547106e9925a79fafa73b04cd36fdae90fe541e561ca568dd09c4f"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "8dcd9c2788ad48ec1f969fc21b61e1a0c09dded3f090691544f86aa6f5fb3786" => :catalina
    sha256 "e9fda0e335c92d25dec9e8c6853c89e4ad16bad0fe25789b9a75284f62601664" => :mojave
    sha256 "d25c3f5e963c994f0677b3e68aa38da9ea45944c2d0c04f983ae859af4f171ea" => :high_sierra
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

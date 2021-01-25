class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://github.com/kumahq/kuma/archive/1.0.6.tar.gz"
  sha256 "3d93c7508174d456a1d8a50f64227d243fa1226f8116c3dac6c044b246698415"
  license "Apache-2.0"
  revision 1

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "2c26ea50fe8fd70b8f2766c125b1db02707a0dee7abf2cdd0d920f11884f1183" => :big_sur
    sha256 "5467c29fb7c9d1c3f8dc987ad547402a8e7fd1df31cdca26ded0ad69bdfc4927" => :arm64_big_sur
    sha256 "fe790a9476a92d8e4cb1bc06b99efdeb9e585d80db10d8af4a57c7800b2d3af1" => :catalina
    sha256 "a0907bc36178a750a9c5e9e7707d7494bee7e7ceed5490da9875dfc46a8b9a72" => :mojave
  end

  depends_on "go" => :build

  def install
    srcpath = buildpath/"src/kuma.io/kuma"
    srcpath.install buildpath.children

    cd srcpath do
      system "make", "build/kumactl", "BUILD_INFO_VERSION=#{version}"
      bin.install Dir["build/artifacts-*/kumactl/kumactl"].first
    end

    output = Utils.safe_popen_read("#{bin}/kumactl", "completion", "bash")
    (bash_completion/"kumactl").write output

    output = Utils.safe_popen_read("#{bin}/kumactl", "completion", "zsh")
    (zsh_completion/"_kumactl").write output

    output = Utils.safe_popen_read("#{bin}/kumactl", "completion", "fish")
    (fish_completion/"kumactl.fish").write output
  end

  test do
    assert_match "Management tool for Kuma.", shell_output("#{bin}/kumactl")
    assert_match version.to_s, shell_output("#{bin}/kumactl version 2>&1")

    touch testpath/"config.yml"
    assert_match "Error: no resource(s) passed to apply",
    shell_output("#{bin}/kumactl apply -f config.yml 2>&1", 1)
  end
end

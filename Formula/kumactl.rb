class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://github.com/kumahq/kuma/archive/1.0.6.tar.gz"
  sha256 "3d93c7508174d456a1d8a50f64227d243fa1226f8116c3dac6c044b246698415"
  license "Apache-2.0"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "d22ab1e7d9e6da7e903b5726dcc537af8f18e32418bc402993a816b534277583" => :big_sur
    sha256 "6fbacebfb67fa9351a3bd17567406f3f306755695eacaa458facd0506b3fd3fa" => :arm64_big_sur
    sha256 "a31bd84333e97c744e12ef4451b69c1dd954b30a8a31cf49d7e8771ccc07d65e" => :catalina
    sha256 "361e3c9056d5643ac1e64b2d75927e746484dcb12c89c8d53001181633fdfd15" => :mojave
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

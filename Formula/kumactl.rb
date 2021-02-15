class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://github.com/kumahq/kuma/archive/1.0.7.tar.gz"
  sha256 "eb010a00e9f3c0f70db425348b1a69b136dd6d3a863251a2ec2c92383dc17c5e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6fbacebfb67fa9351a3bd17567406f3f306755695eacaa458facd0506b3fd3fa"
    sha256 cellar: :any_skip_relocation, big_sur:       "d22ab1e7d9e6da7e903b5726dcc537af8f18e32418bc402993a816b534277583"
    sha256 cellar: :any_skip_relocation, catalina:      "a31bd84333e97c744e12ef4451b69c1dd954b30a8a31cf49d7e8771ccc07d65e"
    sha256 cellar: :any_skip_relocation, mojave:        "361e3c9056d5643ac1e64b2d75927e746484dcb12c89c8d53001181633fdfd15"
  end

  depends_on "go" => :build

  # Fix build on ARM, remove in next version
  patch do
    url "https://github.com/kumahq/kuma/commit/f96cfbc1cd61ddb14e9fb7ca3b47e13983981404.patch?full_index=1"
    sha256 "3a75649e5c769a5b8303efe40983f8d865adab8a9201650fa7d210a35db22b11"
  end

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

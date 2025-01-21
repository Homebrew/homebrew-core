class ConsulTemplate < Formula
  desc "Generic template rendering and notifications with Consul"
  homepage "https://github.com/hashicorp/consul-template"
  url "https://github.com/hashicorp/consul-template/archive/refs/tags/v0.39.1.tar.gz"
  sha256 "864a81cb114c3aa079c185226acf869cbccef03f1ae525d88a6d929d2b7a64f4"
  license "MPL-2.0"
  head "https://github.com/hashicorp/consul-template.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "241086dbcd92027f8c28c0c526afaecee7083faf6769b18da3df01864f41145f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e94ae8bac9e71da4f91b25bfb301728c6a0255a92cd43838e4179857027d22e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "89ad41bf65fc9f430b17ed8a789a36a28c870977936cc0ba9d71c68069b27baa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e167655f9b1be88a2c2a254855fe2888b538a3f048ea94280707e17709b6cb46"
    sha256 cellar: :any_skip_relocation, sonoma:         "7ddaac2a8089187a7a3b968c4eeb6f40a2882ffdcf7a3d09d539432dfb9948cd"
    sha256 cellar: :any_skip_relocation, ventura:        "e89f2997a3595d91896706d6e09202028f93ae8a126b6630943317dc5eabba7c"
    sha256 cellar: :any_skip_relocation, monterey:       "a8a53aa07b37cbf6164d0e17c617b5ca0c60c3660c9c23b9eaad23a7c907c1bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43250e2791cddb58e5b9f8a7d640e2de2a393046a9453fb7968bb866703ad353"
  end

  depends_on "go" => :build

  def install
    project = "github.com/hashicorp/consul-template"
    ldflags = %W[
      -s -w
      -X #{project}/version.Name=consul-template
      -X #{project}/version.GitCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    (testpath/"template").write <<~EOS
      {{"homebrew" | toTitle}}
    EOS
    system bin/"consul-template", "-once", "-template", "template:test-result"
    assert_equal "Homebrew", (testpath/"test-result").read.chomp
  end
end

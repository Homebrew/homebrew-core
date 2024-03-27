class ConsulTemplate < Formula
  desc "Generic template rendering and notifications with Consul"
  homepage "https://github.com/hashicorp/consul-template"
  url "https://github.com/hashicorp/consul-template.git",
      tag:      "v0.37.4",
      revision: "e3ced0f46b08b2ec4c46c532469933b6a2118ef5"
  license "MPL-2.0"
  head "https://github.com/hashicorp/consul-template.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7165cf0c9fceff8a4fd7595673db2d869749e6f725fa5ebbcd88c3889f6cc877"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bec204b8c9003f7fd40baa7c596c237c2312a5c8ffcc73659e4eabf262b9dbaa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1218acae5eb076b830bc58be05cf4f013ecd642b17f3b97beab8820059fe4cf"
    sha256 cellar: :any_skip_relocation, sonoma:         "92cf4d1e1f805233c6c507625bbe83027be405cb7d2c45c5025e90f341d84fbf"
    sha256 cellar: :any_skip_relocation, ventura:        "cf6d74439ba8fe27f091718ac9c6d97b90f42e620daa516fcb7bcbcbfb94e4b8"
    sha256 cellar: :any_skip_relocation, monterey:       "d665259e94b151ef3dade5a7ae93ac47c55600c0c0d1e3b6792628aa27194926"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0ad6557bd46846c3d41ac083400bc40e5db79aec4d610a6e173393c666c68e9"
  end

  depends_on "go" => :build

  def install
    project = "github.com/hashicorp/consul-template"
    ldflags = %W[
      -s -w
      -X #{project}/version.Name=consul-template
      -X #{project}/version.GitCommit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags:)
    prefix.install_metafiles
  end

  test do
    (testpath/"template").write <<~EOS
      {{"homebrew" | toTitle}}
    EOS
    system bin/"consul-template", "-once", "-template", "template:test-result"
    assert_equal "Homebrew", (testpath/"test-result").read.chomp
  end
end

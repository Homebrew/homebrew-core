class ConsulTemplate < Formula
  desc "Generic template rendering and notifications with Consul"
  homepage "https://github.com/hashicorp/consul-template"
  url "https://github.com/hashicorp/consul-template/archive/refs/tags/v0.41.3.tar.gz"
  sha256 "d2a5d9dea3f34be634bc733be0ba1d8448cd341c93392efc187d36e97dd7c2f2"
  license "MPL-2.0"
  head "https://github.com/hashicorp/consul-template.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1889950f795aee8a149340d2dcf723352b3507e4d53fd3df648bd8e100122288"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1889950f795aee8a149340d2dcf723352b3507e4d53fd3df648bd8e100122288"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1889950f795aee8a149340d2dcf723352b3507e4d53fd3df648bd8e100122288"
    sha256 cellar: :any_skip_relocation, sonoma:        "75156483736f9da5b276b57c049de6b4df3dea713cab494ec5a9f718555cd78d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "843d9021bdc182bd9c404ec0be971997fd911b3d2efc767ab84427b84e8ab8ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "138cdf61a6ec80fc904a2288e863cdf4bc226c9c055651fa29488d47f4404d33"
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

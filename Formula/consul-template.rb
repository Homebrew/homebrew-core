class ConsulTemplate < Formula
  desc "Generic template rendering and notifications with Consul"
  homepage "https://github.com/hashicorp/consul-template"
  url "https://github.com/hashicorp/consul-template.git",
      tag:      "v0.27.0",
      revision: "d4af0222e8853b1ae1435cadf0b819651a6f149b"
  license "MPL-2.0"
  head "https://github.com/hashicorp/consul-template.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "954a0becbeafa3a6e0811ee83b749e9711f41302125713484edc3692e5b32449"
    sha256 cellar: :any_skip_relocation, big_sur:       "87d005515948c2685d0d1bfddf3be691e23f0ba13dd9d1d23df33e039378dd70"
    sha256 cellar: :any_skip_relocation, catalina:      "97ab8ab5bd375ad6123c7c5619051c7928644815890fb00ab1d99f8eaa7d7d07"
    sha256 cellar: :any_skip_relocation, mojave:        "b1a6257d01f844bce985509fa786f4352d28f418caa49908a54b804401145646"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a9dc180cc14a3a33cf9ff92c18f6519714ec62981f44a95a1999cb16bdf651d"
  end

  depends_on "go" => :build

  def install
    project = "github.com/hashicorp/consul-template"
    ldflags = %W[
      -s -w
      -X #{project}/version.Name=consul-template
      -X #{project}/version.GitCommit=#{Utils.git_short_head}
    ]
    system "go", "build", "-ldflags", ldflags.join(" "), *std_go_args
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

class ConsulTemplate < Formula
  desc "Generic template rendering and notifications with Consul"
  homepage "https://github.com/hashicorp/consul-template"
  url "https://github.com/hashicorp/consul-template.git",
      tag:      "v0.26.0",
      revision: "3b7f233ac5e22ac50bbebaf522bfff7516f85aa2"
  license "MPL-2.0"
  head "https://github.com/hashicorp/consul-template.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "56b59914fc661788361c781d81bbebadf5c271869ef2cf1a2b07a55aae2507d0"
    sha256 cellar: :any_skip_relocation, big_sur:       "b0e75b93a96a65db4c740c4f9cb182a4f9633453b19642596f0166e758fcf0ac"
    sha256 cellar: :any_skip_relocation, catalina:      "9b9b74bf2862b9da6fbe3b09800d035ea6cb02a4a955a20e61d4263b6bce97b9"
    sha256 cellar: :any_skip_relocation, mojave:        "c53892e3727810906a27b366a8b6f25faa5fae481289027e156767f5ab770878"
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

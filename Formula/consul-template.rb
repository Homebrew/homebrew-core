class ConsulTemplate < Formula
  desc "Generic template rendering and notifications with Consul"
  homepage "https://github.com/hashicorp/consul-template"
  url "https://github.com/hashicorp/consul-template.git",
      tag:      "v0.25.1",
      revision: "171d54d1d3e732a7e960988b72ff9c2fddb3cd8f"
  license "MPL-2.0"
  head "https://github.com/hashicorp/consul-template.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "978bab61f0209e37b5a14a1af8d9b55a767701cb5cded8107e9c7447e5e0b78d" => :big_sur
    sha256 "5aa4fc41916cedf03968b7f7b1264acd67884f5277dfebd0c072185457b061f8" => :arm64_big_sur
    sha256 "79c0b42239bae3e2771b9cce86d2e816654126aa6c5907be3999eadec34ecd8a" => :catalina
    sha256 "169f7d647729d546330b8268f5e07eb378fc95e35831fb6f24d508901f607499" => :mojave
    sha256 "37f32e5b0d9e2ffc20846be7f4e97607e76f5b27b29cf015c941c9c03cc506f4" => :high_sierra
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

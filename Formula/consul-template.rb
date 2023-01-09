class ConsulTemplate < Formula
  desc "Generic template rendering and notifications with Consul"
  homepage "https://github.com/hashicorp/consul-template"
  url "https://github.com/hashicorp/consul-template.git",
      tag:      "v0.30.0",
      revision: "28bba127e9d123b63d33f8fd5cd68ea27919479d"
  license "MPL-2.0"
  head "https://github.com/hashicorp/consul-template.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ab1021ff0ff7a0f460673ac355aadcdf89f83f48b50686bf0539d260d7b582df"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "376ad53fdd892f3445ac2124a610cefc6048af53aedf2acf6a8a25da17c8f560"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a81bca194a39fecb92bd52ea3be79b90dbc1a4832aff1dfd3befa006754dbea6"
    sha256 cellar: :any_skip_relocation, ventura:        "b9e924a89bba372009f8a1a0d77132f32a62264dade7f0a42be838768413015d"
    sha256 cellar: :any_skip_relocation, monterey:       "71cf75326324cb38db55914c75eb93feb584809691a48f0af8ce8fcbb025b18f"
    sha256 cellar: :any_skip_relocation, big_sur:        "2cce18d688306e9806184051021264e13d770976485fecf66654be806a72ddce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0d5c7f1dbabc9eec36e260cb404b72c7436ee938ad91636998cbfa001abdf97"
  end

  depends_on "go" => :build

  def install
    project = "github.com/hashicorp/consul-template"
    ldflags = %W[
      -s -w
      -X #{project}/version.Name=consul-template
      -X #{project}/version.GitCommit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
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

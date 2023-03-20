class ConsulTemplate < Formula
  desc "Generic template rendering and notifications with Consul"
  homepage "https://github.com/hashicorp/consul-template"
  url "https://github.com/hashicorp/consul-template.git",
      tag:      "v0.30.0",
      revision: "28bba127e9d123b63d33f8fd5cd68ea27919479d"
  license "MPL-2.0"
  head "https://github.com/hashicorp/consul-template.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "68852894ac9d1c29a7b504819a19190e70640f3b07b75f720bc92d240bab2168"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c039011f40a62dc3deeb9f8fe7a7b387eb4141625eedaf740193349d3d3956af"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "41b0d1cb0bc782086556baa2164dff08b08cc031b2e0d4c2f08bb2df88059649"
    sha256 cellar: :any_skip_relocation, ventura:        "fb74180703216136b00c9cadfcea09b706831d3b527a6dc490dbb3ea7a26b9fc"
    sha256 cellar: :any_skip_relocation, monterey:       "cd4134f0e69741784bbd92c1d301fea0883dd934b67dcaa9b4a39c3a1d6ddfaf"
    sha256 cellar: :any_skip_relocation, big_sur:        "181606776917822e073dbb49b4d71ace02745d833301f6d5c618a8fde19874a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de30cde2509fd426b02dc2293480461750e4fb500b813d49f455d727c8172f57"
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

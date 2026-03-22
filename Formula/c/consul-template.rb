class ConsulTemplate < Formula
  desc "Generic template rendering and notifications with Consul"
  homepage "https://github.com/hashicorp/consul-template"
  url "https://github.com/hashicorp/consul-template/archive/refs/tags/v0.41.4.tar.gz"
  sha256 "44e6113e8ce8f10a1d7d970e432bcf7693f04da664c5d590a92ca9d6777c2ce0"
  license "MPL-2.0"
  head "https://github.com/hashicorp/consul-template.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cd50e82ed464e77fc8a23cb0a5cfa54aa06521221bacc8dba0e3d7b3dbb7a091"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd50e82ed464e77fc8a23cb0a5cfa54aa06521221bacc8dba0e3d7b3dbb7a091"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd50e82ed464e77fc8a23cb0a5cfa54aa06521221bacc8dba0e3d7b3dbb7a091"
    sha256 cellar: :any_skip_relocation, sonoma:        "2076db783aec86f3e549c472edc21aaa7491c0b743725a26b561bf0268a73a6e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b79ba9a0eb28221866fd3f1220ae6470783a4d381d03d01f9d95ed4ef687cb78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ecd0c5ca62803292ab51ef15111b01ad653591645256b5202f0b97e9a23b978"
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

class ConsulTemplate < Formula
  desc "Generic template rendering and notifications with Consul"
  homepage "https://github.com/hashicorp/consul-template"
  url "https://github.com/hashicorp/consul-template.git",
      tag:      "v0.37.0",
      revision: "99646746608b9f4081ab29ca4b47999685918d9a"
  license "MPL-2.0"
  head "https://github.com/hashicorp/consul-template.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7b611791bdfe43e47e9ccedad59a3b1eedca3207c189b5da463357321ce12d82"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6a889aaeacd343959c5cce36f31e4aa70466d698358c80dbb34583159bf15bc7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a08952a5cf099b334e1a7826651de6f79221b8ae778973504e10cf1f8c889a07"
    sha256 cellar: :any_skip_relocation, sonoma:         "82ac8fa068b8e8d70adeb9207813b619af1e0c44153e1437ab21dbc197d9a15b"
    sha256 cellar: :any_skip_relocation, ventura:        "b051a2869ad22c1d9897849e777e0858dcc3de08cb47de415857e155e42bd478"
    sha256 cellar: :any_skip_relocation, monterey:       "d856e2cb38e11c5c4e0a3099e8970758016c7e21dfb18b602c4b9d5ac3d435e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2594febcef0b444f9192c9af10b444d316181c683be50e47fbf0b754fb7a8bc1"
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

class ConsulTemplate < Formula
  desc "Generic template rendering and notifications with Consul"
  homepage "https://github.com/hashicorp/consul-template"
  url "https://github.com/hashicorp/consul-template/archive/refs/tags/v0.37.5.tar.gz"
  sha256 "adee468277b2aadf85397130bf9d8d443ee76cc789a18d89995b1382d2fe0f38"
  license "MPL-2.0"
  head "https://github.com/hashicorp/consul-template.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a3e3bf8b34da66415ead3a159275bc4e7dbbdbde6c8d47473efc2ec2ae0dcb30"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "93295f4cc17f8e7af5ef8a24caf5c2a04adb24975840d90c8e847386d2842c68"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "76e0dca3228837fe82590bda1864c180282bf0a49df2f463c473e8f1f904f779"
    sha256 cellar: :any_skip_relocation, sonoma:         "496eeb6c5001fbce390d865608652e9179d8ef0433d244c8d396e82822f34c91"
    sha256 cellar: :any_skip_relocation, ventura:        "395bb4b3acac541cc527fa1b22ec96ab991f658780c07aea005e482b53ad4ff3"
    sha256 cellar: :any_skip_relocation, monterey:       "b9b4b8ab7d7d1e9bb2222d8c4f8bf1f3e831d6778002f1dd81731bf108edc226"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16b9de1432b8ce3a3a059333c69251ca65ae993b535bd007b04deaf0ae316c79"
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

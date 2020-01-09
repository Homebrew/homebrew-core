class ConsulTemplate < Formula
  desc "Generic template rendering and notifications with Consul"
  homepage "https://github.com/hashicorp/consul-template"
  url "https://github.com/hashicorp/consul-template.git",
      :tag      => "v0.24.0",
      :revision => "a7bcaa73a2ff8a1567efd577a857259f10e9d210"
  head "https://github.com/hashicorp/consul-template.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "a2dde0ecc076871dbdc3a776757d66bf0bc93f7355cc19626f63564a9b3aafbc" => :catalina
    sha256 "c2562a2cad6e348b7627204a9ac5eb93ae14b04c03f1d7ef82006db2c06cbeb5" => :mojave
    sha256 "e651674c59039ed989f07461b4d6953410b373d40d3a7c1cb5fbbb51b6671ab8" => :high_sierra
  end

  depends_on "go" => :build

  def install
    project = "github.com/hashicorp/consul-template"
    commit = Utils.popen_read("git rev-parse --short HEAD").chomp
    ldflags = ["-s", "-w",
               "-X #{project}/version.Name=consul-template",
               "-X #{project}/version.GitCommit=#{commit}"]
    system "go", "build", "-ldflags", ldflags.join(" "), "-trimpath",
           "-o", bin/"consul-template"
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

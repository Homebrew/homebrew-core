class ConsulTemplate < Formula
  desc "Generic template rendering and notifications with Consul"
  homepage "https://github.com/hashicorp/consul-template"
  url "https://github.com/hashicorp/consul-template.git",
      :tag      => "v0.24.0",
      :revision => "a7bcaa73a2ff8a1567efd577a857259f10e9d210"
  head "https://github.com/hashicorp/consul-template.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7d6ba218b40585bfec50e321a39fcd184f54b3934896e7b8740e906f7211b321" => :catalina
    sha256 "bb877b6b83d183aa38f96354404464374ce6dd9be589781924c8840f8d8c401f" => :mojave
    sha256 "977f793446ae540866fd515e4d696622ffb65b6a14ae59ad0ddccb306d3467ce" => :high_sierra
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

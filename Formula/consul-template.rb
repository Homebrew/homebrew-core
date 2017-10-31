class ConsulTemplate < Formula
  desc "Generic template rendering and notifications with Consul"
  homepage "https://github.com/hashicorp/consul-template"
  url "https://github.com/hashicorp/consul-template.git",
      :tag => "v0.19.4",
      :revision => "111a80441153783544817b7c6a9c08633308b9a8"
  head "https://github.com/hashicorp/consul-template.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5edefad550b7fa2c86b7d0484cae79b3b49b7b89c402f38f2b341ea948150410" => :high_sierra
    sha256 "55b7eb1dd13f7fb4a4285a14e3effe27a33667352aee2b3dd1f87dd91b037e7a" => :sierra
    sha256 "0ba3259f899d530ec583de3a10a421fefce9641dc118f59b2c89354ad1cd56bc" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    arch = MacOS.prefer_64_bit? ? "amd64" : "386"
    ENV["XC_OS"] = "darwin"
    ENV["XC_ARCH"] = arch
    dir = buildpath/"src/github.com/hashicorp/consul-template"
    dir.install buildpath.children - [buildpath/".brew_home"]

    cd dir do
      project = "github.com/hashicorp/consul-template"
      commit = Utils.popen_read("git rev-parse --short HEAD").chomp
      ldflags = ["-X #{project}/version.Name=consul-template",
                 "-X #{project}/version.GitCommit=#{commit}"]
      system "go", "build", "-o", bin/"consul-template", "-ldflags",
             ldflags.join(" ")
      prefix.install_metafiles
    end
  end

  test do
    (testpath/"template").write <<~EOS
      {{"homebrew" | toTitle}}
    EOS
    system bin/"consul-template", "-once", "-template", "template:test-result"
    assert_equal "Homebrew", (testpath/"test-result").read.chomp
  end
end

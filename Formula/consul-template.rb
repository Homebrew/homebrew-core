class ConsulTemplate < Formula
  desc "Generic template rendering and notifications with Consul"
  homepage "https://github.com/hashicorp/consul-template"
  url "https://github.com/hashicorp/consul-template.git",
      :tag => "v0.19.2",
      :revision => "7904344b9f673548df88570dc530437b30f5f179"
  head "https://github.com/hashicorp/consul-template.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3f2869bc9d9caf2b6317acda1e1dac26fbc467041e464340922eeb54eab9d90b" => :sierra
    sha256 "786e5d022e6661697578203a7b9eb55ab4b2e266111331a9f2f2eac4719340a2" => :el_capitan
    sha256 "6eddb0da1a29333b5237c5c8a0cb9cb57b5aba6689e3635abf27b61689ad9102" => :yosemite
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
    (testpath/"template").write <<-EOS.undent
      {{"homebrew" | toTitle}}
    EOS
    system bin/"consul-template", "-once", "-template", "template:test-result"
    assert_equal "Homebrew", (testpath/"test-result").read.chomp
  end
end

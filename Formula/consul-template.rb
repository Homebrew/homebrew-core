class ConsulTemplate < Formula
  desc "Generic template rendering and notifications with Consul"
  homepage "https://github.com/hashicorp/consul-template"
  url "https://github.com/hashicorp/consul-template.git",
      :tag => "v0.19.1",
      :revision => "13feebcb176c2deeceb994282e2b09952a746d11"
  head "https://github.com/hashicorp/consul-template.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1c8ee0a9a8c5e075c4ce415e1fc2044df760febae0bc21d2617d608c80f77980" => :sierra
    sha256 "c75d14cc41dfec1eb57d5128057f7c743ee53c9f1c23ae48a936081ae1f7b615" => :el_capitan
    sha256 "19a4ee602df2df0a9f4281724f62bd651a9707a659496c4610fcd74827a23a2c" => :yosemite
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

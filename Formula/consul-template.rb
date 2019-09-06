class ConsulTemplate < Formula
  desc "Generic template rendering and notifications with Consul"
  homepage "https://github.com/hashicorp/consul-template"
  url "https://github.com/hashicorp/consul-template.git",
      :tag      => "v0.21.0",
      :revision => "05c6b650cd48d79d5aae4a603ae24c24ff61098c"
  head "https://github.com/hashicorp/consul-template.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e2386b57528d2c4b8271be7631c92627e1f6ed962f651cc9a8dacd465a2321d7" => :mojave
    sha256 "03ceedf8981565c29f1309f32ec160b811c58f350496e9bc4b0dc3d67bc2ab87" => :high_sierra
    sha256 "8b79694dda58040c7e9f6ce200247fa6a57553f08f2bfd610ecaf4c821c3b657" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GO111MODULE"] = "on"
    ENV["GOPATH"] = buildpath
    ENV["XC_OS"] = "darwin"
    ENV["XC_ARCH"] = "amd64"

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

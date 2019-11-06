class ConsulTemplate < Formula
  desc "Generic template rendering and notifications with Consul"
  homepage "https://github.com/hashicorp/consul-template"
  url "https://github.com/hashicorp/consul-template.git",
      :tag      => "v0.22.0",
      :revision => "005b42eb2414a945dfe205dba58f64cc3546a7b5"
  head "https://github.com/hashicorp/consul-template.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "700b4b2fff421649b3b905446cdff6ef14d7b32b0f4513795170f06ee1b89e8f" => :catalina
    sha256 "5dd743db1a5ae5266d442be1c0c796a96438af5af93c0a7290a8b5077d918441" => :mojave
    sha256 "c801baee22d8143ed9b9fa1a6e632e88c1cc0f989ad8352e372ca3037c90378e" => :high_sierra
    sha256 "182b3fc4162d1ad2975a6c022ef4274c54725134c7e0a795c6eb07997fd22d79" => :sierra
  end

  depends_on "go" => :build

  def install
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

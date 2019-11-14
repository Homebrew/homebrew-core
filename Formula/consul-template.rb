class ConsulTemplate < Formula
  desc "Generic template rendering and notifications with Consul"
  homepage "https://github.com/hashicorp/consul-template"
  url "https://github.com/hashicorp/consul-template.git",
      :tag      => "v0.23.0",
      :revision => "521adf1df1b6640fddc06462c21c645f054f55b4"
  head "https://github.com/hashicorp/consul-template.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "72e9acbe3c7ec5ba23b8cbe5b613d15c4c96e1d3a10d5a74640f9f69a81d0a46" => :catalina
    sha256 "3ce2ab218e3b6379add2f41bb32457fd3e7974cbbbf8a795055e535f590d0dfb" => :mojave
    sha256 "b58cbc3a12ec729d0375df7893f6238e591d6af347bb8a4437f8741a40828dcc" => :high_sierra
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

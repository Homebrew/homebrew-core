class ConsulTemplate < Formula
  desc "Generic template rendering and notifications with Consul"
  homepage "https://github.com/hashicorp/consul-template"
  url "https://github.com/hashicorp/consul-template.git",
      :tag => "v0.19.3",
      :revision => "e08c9043f75346825b122c4b2f9d3dfe27e75c7a"
  head "https://github.com/hashicorp/consul-template.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "44e2c7d45366b3485a03694d3d744afd4fdd213f2bc5aaba862a7decaf802a04" => :high_sierra
    sha256 "98b894e6a5c2ca8e406b558db015ff37e0d96eb0ff42b4507887361753480000" => :sierra
    sha256 "84dfb236c7ca08c26d341e4723a2824e9ad93b1cbd9e238a1d5e3e8a27bbfbff" => :el_capitan
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

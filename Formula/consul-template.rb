class ConsulTemplate < Formula
  desc "Generic template rendering and notifications with Consul"
  homepage "https://github.com/hashicorp/consul-template"
  url "https://github.com/hashicorp/consul-template.git",
      :tag => "v0.18.2",
      :revision => "770d6514fcb34703b594280d73fc5427fe692f1b"
  head "https://github.com/hashicorp/consul-template.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4810a80f495db526959e6f830cf95c6d219b99ddb4915e934b98797bd95552e0" => :sierra
    sha256 "4a131cec77f31b38e8821372adc7f2196cfe7723613c53db41f6cd1c4dfc68bd" => :el_capitan
    sha256 "2e56bcf8fff635631457330a43ee4e5f24901102674020958b5698fbd5c3598e" => :yosemite
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
      system "make", "bin-local"
      bin.install "pkg/darwin_#{arch}/consul-template"
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

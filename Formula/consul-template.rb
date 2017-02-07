class ConsulTemplate < Formula
  desc "Generic template rendering and notifications with Consul"
  homepage "https://github.com/hashicorp/consul-template"
  url "https://github.com/hashicorp/consul-template.git",
      :tag => "v0.18.1",
      :revision => "e9bbed7053974ed6c3b6d329bb3786afa961af01"
  head "https://github.com/hashicorp/consul-template.git"

  bottle do
    sha256 "d3b38ee6b72d76d53073f4bedd734350f31788441517ca324bcdf89dfa11b75e" => :sierra
    sha256 "8e0bd59beeab9335826df18e00bc92da53e6b104d6a73b31bcc2e416ac8e99b2" => :el_capitan
    sha256 "c19f21e76191a6731603cc18fe2b82fc2ace6b7a6337ba1679323fd4fb09e182" => :yosemite
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

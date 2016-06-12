class ConsulTemplate < Formula
  desc "Generic template rendering and notifications with Consul"
  homepage "https://github.com/hashicorp/consul-template"
  url "https://github.com/hashicorp/consul-template.git",
      :tag => "v0.15.0",
      :revision => "6dc5d0f9c4cbc62828c91a923482c2341d36acb3"
  head "https://github.com/hashicorp/consul-template.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "05a53a663c42760365460a44d8cafbc4dc40ad98f508a09ad20d7964fd1f4535" => :el_capitan
    sha256 "59fdd16abde92b3451a30b5c38802144d712c610d42c5045285abce4ba8359f7" => :yosemite
    sha256 "f96f0000fcc10bc50c3a850777a575f2d672f676eb2ff2a65769c3e377ed7998" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV.prepend_create_path "PATH", buildpath/"bin"
    dir = buildpath/"src/github.com/hashicorp/consul-template"
    dir.install buildpath.children
    cd dir do
      system "make", "bootstrap"
      system "make", "updatedeps" if build.head?
      system "make", "dev"
      system "make", "test"
    end
    bin.install "bin/consul-template"
  end

  test do
    (testpath/"template").write <<-EOS.undent
      {{"homebrew" | toTitle}}
    EOS
    system bin/"consul-template", "-once", "-template", "template:test-result"
    assert_equal "Homebrew", (testpath/"test-result").read.chomp
  end
end

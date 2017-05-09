class ConsulTemplate < Formula
  desc "Generic template rendering and notifications with Consul"
  homepage "https://github.com/hashicorp/consul-template"
  url "https://github.com/hashicorp/consul-template.git",
      :tag => "v0.18.3",
      :revision => "3a31dde7d5dbddf2555470021f3e18985f1edd9d"
  head "https://github.com/hashicorp/consul-template.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "aa4acaaff0f85ee7b7860e3b18746d0404657a1c9244999817e06f52c145bf6e" => :sierra
    sha256 "451ae2b901a7d1f28398dbe2be704257869b8e37f89f173bf072adae6a8418e9" => :el_capitan
    sha256 "cf358ac82b4c6ca739ac62b5d1eb092902a5d3d6d38f22b600c9491c3abfd114" => :yosemite
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

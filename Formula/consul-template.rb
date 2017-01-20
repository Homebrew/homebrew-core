class ConsulTemplate < Formula
  desc "Generic template rendering and notifications with Consul"
  homepage "https://github.com/hashicorp/consul-template"
  url "https://github.com/hashicorp/consul-template.git",
      :tag => "v0.18.0",
      :revision => "8bf2ce9e0cdcd60d799a75262b90468d24ee392e"
  head "https://github.com/hashicorp/consul-template.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4a5ed83931505027e4d40f774fb791254e26a8fa232b8932a54cc77665962d38" => :sierra
    sha256 "fd8408ce1b01c0fd07047013a2b658e6ff792c88aad842cf9d978cb90d456eb2" => :el_capitan
    sha256 "844950502c5edb1f0b9797f3dc4d92241616982bfdf272e92c5c42883e53a6c4" => :yosemite
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

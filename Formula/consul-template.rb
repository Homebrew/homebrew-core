class ConsulTemplate < Formula
  desc "Generic template rendering and notifications with Consul"
  homepage "https://github.com/hashicorp/consul-template"
  url "https://github.com/hashicorp/consul-template.git",
      :tag => "v0.19.0",
      :revision => "cfe084f488f915b3e41b00824a3e07d79e3677aa"
  head "https://github.com/hashicorp/consul-template.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "201ed9b01af0cd0497b0c8e5bfe57bef619eb5e03260f51d0df32d56b6b12eba" => :sierra
    sha256 "93fb71ee3dbd13148f489e905a61e5519f72be50b2a86289bae5b6ae33c5515a" => :el_capitan
    sha256 "39c4896fcb42095b2a7a65c7a98414ac97bb007ddeb50ea3deea7dfaaa34d799" => :yosemite
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

class ConsulTemplate < Formula
  desc "Generic template rendering and notifications with Consul"
  homepage "https://github.com/hashicorp/consul-template"
  head "https://github.com/hashicorp/consul-template.git"

  stable do
    url "https://github.com/hashicorp/consul-template.git",
        :tag => "v0.16.0",
        :revision => "efa462daa2b961bff683677146713f4008555fba"

    # The stable block can be removed on next stable version as the below
    # go_resource dependencies are no longer required.
    # Ref: https://github.com/hashicorp/consul-template/issues/793
    require "language/go"
    go_resource "github.com/mitchellh/gox" do
      url "https://github.com/mitchellh/gox.git",
          :revision => "c9740af9c6574448fd48eb30a71f964014c7a837"
    end
    go_resource "github.com/mitchellh/iochan" do
      url "https://github.com/mitchellh/iochan.git",
          :revision => "87b45ffd0e9581375c491fef3d32130bb15c5bd7"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "4a5ed83931505027e4d40f774fb791254e26a8fa232b8932a54cc77665962d38" => :sierra
    sha256 "fd8408ce1b01c0fd07047013a2b658e6ff792c88aad842cf9d978cb90d456eb2" => :el_capitan
    sha256 "844950502c5edb1f0b9797f3dc4d92241616982bfdf272e92c5c42883e53a6c4" => :yosemite
  end

  devel do
    url "https://github.com/hashicorp/consul-template.git",
        :tag => "v0.18.0-rc2",
        :revision => "e446ab16fb567e1ddeb88ef29406b53bdb4ee387"
    version "0.18.0-rc2"
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
      if build.stable?
        # On next stable release, this if/else block can be replaced below with
        # just the steps in the else block.
        Language::Go.stage_deps resources, buildpath/"src"
        ENV.prepend_create_path "PATH", buildpath/"bin"
        cd(buildpath/"src/github.com/mitchellh/gox") { system "go", "install" }
        system "make", "dev"
        bin.install "bin/consul-template"
      else
        system "make", "bin-local"
        bin.install "pkg/darwin_#{arch}/consul-template"
      end
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

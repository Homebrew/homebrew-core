require "language/go"

class ConsulTemplate < Formula
  desc "Generic template rendering and notifications with Consul"
  homepage "https://github.com/hashicorp/consul-template"
  url "https://github.com/hashicorp/consul-template.git",
      :tag => "v0.15.0",
      :revision => "6dc5d0f9c4cbc62828c91a923482c2341d36acb3"
  head "https://github.com/hashicorp/consul-template.git"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "49c894d63c468c091027e200746a4c5aef63303407b96a8e51d87240a2596103" => :el_capitan
    sha256 "32ff7ce9b758e60b7194a3d403a57177737967046cbf88d461437eda4cf0c85a" => :yosemite
    sha256 "e1567a7ebe4e7f7c0710f47138566044acca5f4694181566b662f8884025ddaf" => :mavericks
  end

  devel do
    url "https://github.com/hashicorp/consul-template.git",
        :tag => "v0.16.0-rc1",
        :revision => "95065346ba9a95564536f2154dfb054c18cc5cc3"
    version "0.16.0-rc1"
  end

  depends_on "go" => :build

  go_resource "github.com/mitchellh/gox" do
    url "https://github.com/mitchellh/gox.git",
        :revision => "6e9ee79eab7bb1b84155379b3f94ff9a87b344e4"
  end

  # gox dependency
  go_resource "github.com/mitchellh/iochan" do
    url "https://github.com/mitchellh/iochan.git",
        :revision => "87b45ffd0e9581375c491fef3d32130bb15c5bd7"
  end

  def install
    ENV["GOPATH"] = buildpath

    dir = buildpath/"src/github.com/hashicorp/consul-template"
    dir.install buildpath.children

    Language::Go.stage_deps resources, buildpath/"src"
    ENV.prepend_create_path "PATH", buildpath/"bin"
    cd("src/github.com/mitchellh/gox") { system "go", "install" }

    cd dir do
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

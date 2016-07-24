require "language/go"

class Pup < Formula
  desc "Parse HTML at the command-line"
  homepage "https://github.com/EricChiang/pup"
  url "https://github.com/ericchiang/pup/archive/v0.4.0.tar.gz"
  sha256 "0d546ab78588e07e1601007772d83795495aa329b19bd1c3cde589ddb1c538b0"
  head "https://github.com/EricChiang/pup.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e3766f1c194ece7e6eea245627c6ca2ae83d7a7cd33dfaf61da53ad85577dfd6" => :el_capitan
    sha256 "0c3f2f89d57313b4d5d90a73c39e5187470e7dd9f35a0d8b030d518f69b21766" => :yosemite
    sha256 "5bc9ab2b8ecb14048115c876bf77a7490139715d3250407785159aa2b72faf8f" => :mavericks
    sha256 "da53aea34a10ecba854eb3f65b451e99fa4dbe5134261ef2deadff8266ff49e2" => :mountain_lion
  end

  depends_on "go" => :build

  go_resource "github.com/mitchellh/iochan" do
    url "https://github.com/mitchellh/iochan.git",
        :revision => "87b45ffd0e9581375c491fef3d32130bb15c5bd7"
  end

  go_resource "github.com/mitchellh/gox" do
    url "https://github.com/mitchellh/gox.git",
        :revision => "6e9ee79eab7bb1b84155379b3f94ff9a87b344e4"
  end

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/ericchiang/pup"
    dir.install buildpath.children

    Language::Go.stage_deps resources, buildpath/"src"
    ENV.prepend_create_path "PATH", buildpath/"bin"
    cd("src/github.com/mitchellh/gox") { system "go", "install" }

    cd dir do
      arch = MacOS.prefer_64_bit? ? "amd64" : "386"
      system "gox", "-arch", arch, "-os", "darwin", "./..."
      bin.install "pup_darwin_#{arch}" => "pup"
    end

    prefix.install_metafiles dir
  end

  test do
    output = pipe_output("#{bin}/pup p text{}", "<body><p>Hello</p></body>", 0)
    assert_equal "Hello", output.chomp
  end
end

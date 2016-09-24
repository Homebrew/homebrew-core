require "language/go"

class Aptly < Formula
  desc "Swiss army knife for Debian repository management"
  homepage "https://www.aptly.info/"
  url "https://github.com/smira/aptly/archive/v0.9.7.tar.gz"
  sha256 "364d7b294747512c7e7a27f1b4c1d3f1e3f8b502944be142f9ab48a58ebe9a69"
  head "https://github.com/smira/aptly.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "76d08ae0643257baf4f6af5a60022251306f56bbafd24004f6ca415ebbaa2134" => :el_capitan
    sha256 "559e5c4c7fc0435597615fc6cd01a987ad66abe0ba7e49ff0284b1df46894374" => :yosemite
    sha256 "d53b704d71fd7f06425c48345b190125889ea5a8768d2b2a538c41d1b8c0e542" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/daviddengcn/go-colortext" do
    url "https://github.com/daviddengcn/go-colortext.git",
        :revision => "511bcaf42ccd42c38aba7427b6673277bf19e2a1"
  end

  go_resource "github.com/hashicorp/go-version" do
    url "https://github.com/hashicorp/go-version.git",
        :revision => "0181db47023708a38c2d20d2fe25a5fa034d5743"
  end

  go_resource "github.com/mattn/gover" do
    url "https://github.com/mattn/gover.git",
        :revision => "715629d6b57a2104c5221dc72514cfddc992e1de"
  end

  go_resource "github.com/mattn/gom" do
    url "https://github.com/mattn/gom.git",
        :revision => "393e714d663c35e121a47fec32964c44a630219b"
  end

  def install
    ENV["GOPATH"] = buildpath
    ENV.prepend_create_path "PATH", buildpath/"bin"

    (buildpath/"src/github.com/smira").mkpath
    ln_s buildpath, buildpath/"src/github.com/smira/aptly"

    Language::Go.stage_deps resources, buildpath/"src"

    cd("src/github.com/mattn/gom") { system "go", "install" }

    system "gom", "-production", "install"
    system "gom", "build", "-o", bin/"aptly"
  end

  test do
    assert_match "aptly version:", shell_output("#{bin}/aptly version")
    (testpath/".aptly.conf").write("{}")
    result = shell_output("#{bin}/aptly -config='#{testpath}/.aptly.conf' mirror list")
    assert_match "No mirrors found, create one with", result
  end
end

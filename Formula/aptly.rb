require "language/go"

class Aptly < Formula
  desc "Swiss army knife for Debian repository management"
  homepage "https://www.aptly.info/"
  url "https://github.com/smira/aptly/archive/v0.9.7.tar.gz"
  sha256 "364d7b294747512c7e7a27f1b4c1d3f1e3f8b502944be142f9ab48a58ebe9a69"
  head "https://github.com/smira/aptly.git"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "1e64c023404ad78dd260d4c1cca0f080d3ef3903cf61452e698809b32821370f" => :el_capitan
    sha256 "50233a52a6021e47b50a0280263984fda75bfe8811a384f31fc1975e579646a1" => :yosemite
    sha256 "c12651d38a4145136c2d8441c0a1a77e4f4da14697ff9983482b4ce95a728683" => :mavericks
    sha256 "9d3780503b8d9416435f4e8bfd85673e9caf4745657bfaba889ba7000c7e1bb0" => :mountain_lion
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

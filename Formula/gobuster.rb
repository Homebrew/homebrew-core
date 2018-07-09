require "language/go"

class Gobuster < Formula
  desc "Directory/file & DNS busting tool written in Go"
  homepage "https://github.com/OJ/gobuster"
  url "https://github.com/OJ/gobuster/archive/v1.4.2.tar.gz"
  sha256 "e90990f45f06324eb2378369b795a526a6145ca12c8a631493505f1ecfada74f"
  head "https://github.com/OJ/gobuster.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "622f6ae519106998035453cee81ff8cdb32ed7ad3f2716d696849dc997be1df6" => :high_sierra
    sha256 "bbd186fd418fe6dd77dcd10b6de75d458743adc5e693982e6b6dee625b51aad1" => :sierra
    sha256 "51de1f0b5a67b69fe083960945dd8e4951fcf25076e319332a47b379bc94aaf6" => :el_capitan
  end

  depends_on "go" => :build

  go_resource "github.com/hashicorp/go-multierror" do
    url "https://github.com/hashicorp/go-multierror.git",
        :revision => "b7773ae218740a7be65057fc60b366a49b538a44"
  end

  go_resource "github.com/satori/go.uuid" do
    url "https://github.com/satori/go.uuid.git",
        :revision => "36e9d2ebbde5e3f13ab2e25625fd453271d6522e"
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git",
        :revision => "a49355c7e3f8fe157a85be2f77e6e269a0f89602"
  end

  go_resource "golang.org/x/sys" do
    url "https://go.googlesource.com/sys.git",
        :revision => "1b2967e3c290b7c545b3db0deeda16e9be4f98a2"
  end

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/OJ").mkpath
    ln_sf buildpath, buildpath/"src/github.com/OJ/gobuster"
    Language::Go.stage_deps resources, buildpath/"src"
    system "go", "build", "-o", bin/"gobuster"
  end

  test do
    assert_match(/\[!\] WordList \(-w\): Must be specified/, shell_output("#{bin}/gobuster -q"))
  end
end

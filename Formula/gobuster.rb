require "language/go"

class Gobuster < Formula
  desc "Directory/file & DNS busting tool written in Go"
  homepage "https://github.com/OJ/gobuster"
  url "https://github.com/OJ/gobuster/archive/v2.0.1.tar.gz"
  sha256 "2409acffe1fa46424a1de465bca1d3d026bdaba9a7e6bccc1d934f7ae51c24e0"
  head "https://github.com/OJ/gobuster.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8333bbd8af7dd797ac537138a3cc5f43e84dca5f8f405c73e78ac4c8dc051b19" => :mojave
    sha256 "396aae866477abbcd373a0419e6e6a554403bc9f6500df0b564c704947324021" => :high_sierra
    sha256 "56ab5f1e20a60feae0da0c76bbc3902363189889b94013f95348fa1d2d05ca5a" => :sierra
    sha256 "df059226d63e3a19c8d0e9c2355e67872ec3db5a8df25683b1706771b8cc6558" => :el_capitan
  end

  depends_on "go" => :build

  go_resource "github.com/hashicorp/errwrap" do
    url "https://github.com/hashicorp/errwrap.git",
        :revision => "8a6fb523712970c966eefc6b39ed2c5e74880354"
  end

  go_resource "github.com/hashicorp/go-multierror" do
    url "https://github.com/hashicorp/go-multierror.git",
        :revision => "886a7fbe3eb1c874d46f623bfa70af45f425b3d1"
  end

  go_resource "github.com/google/uuid" do
    url "https://github.com/google/uuid.git",
        :revision => "e704694aed0ea004bb7eb1fc2e911d048a54606a"
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git",
        :revision => "182538f80094b6a8efaade63a8fd8e0d9d5843dd"
  end

  go_resource "golang.org/x/sys" do
    url "https://go.googlesource.com/sys.git",
        :revision => "49385e6e15226593f68b26af201feec29d5bba22"
  end

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/OJ").mkpath
    ln_sf buildpath, buildpath/"src/github.com/OJ/gobuster"
    Language::Go.stage_deps resources, buildpath/"src"
    system "go", "build", "-o", bin/"gobuster"
  end

  test do
    (testpath/"words.txt").write <<~EOS
      dog
      cat
      horse
      snake
      ape
    EOS

    output = shell_output("#{bin}/gobuster -u https://buffered.io -w words.txt 2>&1")
    assert_match "Finished", output
  end
end

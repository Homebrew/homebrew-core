require "language/go"

class Gobuster < Formula
  desc "Directory/file & DNS busting tool written in Go"
  homepage "https://github.com/OJ/gobuster"
  url "https://github.com/OJ/gobuster/archive/v2.0.1.tar.gz"
  sha256 "2409acffe1fa46424a1de465bca1d3d026bdaba9a7e6bccc1d934f7ae51c24e0"
  head "https://github.com/OJ/gobuster.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "93569cf756f7af5beea356d5eb0268a3417817884db28cb376912164bf33b522" => :mojave
    sha256 "5b9242b221840de7f36b70fc1942d939b107cf753df7ec38bff59610e5708055" => :high_sierra
    sha256 "45026bb16e7cb74a0e01779d5215e62b96f3cde44c5af879786acca524a3fa42" => :sierra
    sha256 "3f76c44c22a2d08796db6e2b371df9065e67276bc32a8494cce5d34367230da3" => :el_capitan
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

require "language/go"

class Karn < Formula
  desc "Manage multiple Git identities"
  homepage "https://github.com/prydonius/karn"
  url "https://github.com/prydonius/karn/archive/v0.0.3.tar.gz"
  sha256 "a9336abe63dbf6b952e1e4a3d4c31ed62dda69aa51e53f07902edb894638162d"

  bottle do
    cellar :any_skip_relocation
    sha256 "46a84a4885f8d8af04273911c16aa4a7d2a39390eb116257e9868ba30e1b9562" => :sierra
    sha256 "2f8c0c979d0f9adf7bb99b3fe84136af6c261445544f23fe7ed12d543a0e5485" => :el_capitan
    sha256 "8ee7e6511ddfbcf8f5f7edc6f42bbbe6662e20e9ee029f7f2d13bb66e9fbf9e8" => :yosemite
    sha256 "16d1efcf64c807f2db0a270fcff9b973eaf54c280af2819615fdaa46ff6cabc8" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/codegangsta/cli" do
    url "https://github.com/codegangsta/cli.git",
        :revision => "f47f7b7e8568e846e9614acd5738092c3acf7058"
  end

  go_resource "github.com/mitchellh/go-homedir" do
    url "https://github.com/mitchellh/go-homedir.git",
        :revision => "7d2d8c8a4e078ce3c58736ab521a40b37a504c52"
  end

  go_resource "gopkg.in/yaml.v2" do
    url "https://gopkg.in/yaml.v2",
        :revision => "49c95bdc21843256fb6c4e0d370a05f24a0bf213", :using => :git
  end

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/prydonius"
    ln_s buildpath, buildpath/"src/github.com/prydonius/karn"
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "cmd/karn/karn.go"
    bin.install "karn"
  end

  test do
    (testpath/".karn.yml").write <<-EOS.undent
      ---
      #{testpath}:
        name: Homebrew Test
        email: test@brew.sh
    EOS
    system "git", "init"
    system "git", "config", "--global", "user.name", "Test"
    system "git", "config", "--global", "user.email", "test@test.com"
    system "#{bin}/karn", "update"
  end
end

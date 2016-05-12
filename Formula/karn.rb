require "language/go"

class Karn < Formula
  desc "Manage multiple Git identities"
  homepage "https://github.com/prydonius/karn"
  url "https://github.com/prydonius/karn/archive/v0.0.3.tar.gz"
  sha256 "a9336abe63dbf6b952e1e4a3d4c31ed62dda69aa51e53f07902edb894638162d"

  bottle do
    cellar :any_skip_relocation
    sha256 "a74f06c146b24ba79abe246b23873f16daaa25eec4891dac297b8c64935748f1" => :el_capitan
    sha256 "217c56700267f33763c3d2c19cb16f568ede2a9354497377639d26c6998f5490" => :yosemite
    sha256 "25ac0041b1023e2b703468d194e554d2dc42664f496f2ca53082003684477ece" => :mavericks
    sha256 "0c5c97266aa7b34fdabaf54b6877b67d279fa643dc264b7f1a1926f2dd1f3790" => :mountain_lion
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

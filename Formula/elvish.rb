require "language/go"

class Elvish < Formula
  desc "Novel UNIX shell written in Go"
  homepage "https://github.com/elves/elvish"
  url "https://github.com/elves/elvish/archive/0.3.tar.gz"
  sha256 "83d463667055f38367302921e8d87c274ae71fc777f6ffb176dad96e875378e8"
  head "https://github.com/elves/elvish.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6fb11ca99a3e97bd042b7b560a7579795c49c2186578e6eef12c81b3560af3aa" => :el_capitan
    sha256 "0c11cb7e7a4adab892b2aaa94639aac35e9be7a48bba45e69e6354c3da470b49" => :yosemite
    sha256 "c252a2f6485139885943487e40baf406609943f26959b85037aa1cc8b8f7b959" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/elves/getopt" do
    url "https://github.com/elves/getopt.git",
        :revision => "f91a7bf920995832d55a1182f26657bc975b9c24"
  end

  go_resource "github.com/mattn/go-sqlite3" do
    url "https://github.com/mattn/go-sqlite3.git",
        :revision => "3fb7a0e792edd47bf0cf1e919dfc14e2be412e15"
  end

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/elves").mkpath
    ln_sf buildpath, buildpath/"src/github.com/elves/elvish"
    Language::Go.stage_deps resources, buildpath/"src"
    system "go", "build", "-o", bin/"elvish"
    system "make", "-C", "src/github.com/elves/elvish", "stub"
    bin.install "bin/elvish-stub"
  end

  test do
    assert_match "hello", shell_output("#{bin}/elvish -c 'echo hello'")
  end
end

require "language/go"

class Gdm < Formula
  desc "Go Dependency Manager (gdm)"
  homepage "https://github.com/sparrc/gdm"
  url "https://github.com/sparrc/gdm/archive/1.3.tar.gz"
  sha256 "e545378699a557e6dffedb1c25f54ea4f1bf93c1c825ec693f81f391569c8529"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "f001589cc8c409c1467d283bdb84f9c47728642f15a41eb303f82893a79e38d0" => :el_capitan
    sha256 "18be3e8bb793367d43425f4278958c7f301c78b7093bb8d47c9fc14b5aa3b7e3" => :yosemite
    sha256 "c090c98afe08e42e164aa61a0e9034c48d279b2e96ea2197ab7f7b9239a86e96" => :mavericks
  end

  depends_on "go"

  go_resource "golang.org/x/tools" do
    url "https://go.googlesource.com/tools.git",
    :revision => "6f233b96dfbc53e33b302e31b88814cf74697ff6"
  end

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/sparrc"
    ln_sf buildpath, buildpath/"src/github.com/sparrc/gdm"

    Language::Go.stage_deps resources, buildpath/"src"

    cd "src/github.com/sparrc/gdm" do
      system "go", "build", "-o", bin/"gdm",
             "-ldflags", "-X main.Version=#{version}"
    end
  end

  test do
    ENV["GOPATH"] = testpath.realpath
    assert_match version.to_s, shell_output("#{bin}/gdm version")
    assert_match testpath.realpath.to_s, shell_output("#{bin}/gdm save")
    system bin/"gdm", "restore"
  end
end

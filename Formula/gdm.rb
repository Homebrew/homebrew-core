require "language/go"

class Gdm < Formula
  desc "Go Dependency Manager (gdm)"
  homepage "https://github.com/sparrc/gdm"
  url "https://github.com/sparrc/gdm/archive/1.4.tar.gz"
  sha256 "2ac8800319d922fe2816e57f30e23ddd9a11ce2e93294c533318b9f081debde4"
  head "https://github.com/sparrc/gdm.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1271ce8ff02868997451491819027d10c362a9d6b72d10c9cbdafeb80ebbe747" => :sierra
    sha256 "b3f081076a078f90f6a534ff30ff268c89baec38bd02ff11c9e02804755c8c33" => :el_capitan
    sha256 "03f2d8cbcee0c4e41a00ec222f56b7d3204290b075afafe28afe6ced3458ebd8" => :yosemite
    sha256 "a5b111a00c19c74400787394eead8b5a209f9ee64125a5365eae97fa3d78d38a" => :mavericks
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

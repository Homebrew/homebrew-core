require "language/go"

class Gdm < Formula
  desc "Go Dependency Manager (gdm)"
  homepage "https://github.com/sparrc/gdm"
  url "https://github.com/sparrc/gdm/archive/1.4.tar.gz"
  sha256 "2ac8800319d922fe2816e57f30e23ddd9a11ce2e93294c533318b9f081debde4"
  license "Unlicense"
  head "https://github.com/sparrc/gdm.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "45fa20615c4ff168b2753f538d396a9a92cc851ead7eab94c2a21faac5bee814"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "684b0b0f11a168b38500f0e9c4e8419bf39979501014f5e4a5177be2ac5352f1"
    sha256 cellar: :any_skip_relocation, monterey:       "4ee869fe61efff2e95c1979ee051a5209d2fae0ca4b74585b678c9fdcce5f9d8"
    sha256 cellar: :any_skip_relocation, big_sur:        "fc0e6626aec33649015a5808dd6c2b2d5b73051ff71231c6b482bba9e599efc1"
    sha256 cellar: :any_skip_relocation, catalina:       "a9801987792b8b32d8e1a30d668e43a36c798f2901149dbd49f4f8f0f79b45b7"
    sha256 cellar: :any_skip_relocation, mojave:         "655848c2fdb17aea2fd7f3f80a537d115b6e31232927c7cda7fac3b22f5d47a5"
    sha256 cellar: :any_skip_relocation, high_sierra:    "f9d1d9d11a51359be57311d0e896dc797637905d0b8e68340a3e5d6ad2dc962d"
    sha256 cellar: :any_skip_relocation, sierra:         "1271ce8ff02868997451491819027d10c362a9d6b72d10c9cbdafeb80ebbe747"
    sha256 cellar: :any_skip_relocation, el_capitan:     "b3f081076a078f90f6a534ff30ff268c89baec38bd02ff11c9e02804755c8c33"
    sha256 cellar: :any_skip_relocation, yosemite:       "03f2d8cbcee0c4e41a00ec222f56b7d3204290b075afafe28afe6ced3458ebd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0f0a95d921a3fe45e5f7eb32d5132f56d429475118c43e46de3e767edb9eeb0"
  end

  depends_on "go"

  go_resource "golang.org/x/tools" do
    url "https://go.googlesource.com/tools.git",
        revision: "6f233b96dfbc53e33b302e31b88814cf74697ff6"
  end

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
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
    ENV["GO111MODULE"] = "auto"
    assert_match version.to_s, shell_output("#{bin}/gdm version")
    assert_match testpath.realpath.to_s, shell_output("#{bin}/gdm save")
    system bin/"gdm", "restore"
  end
end

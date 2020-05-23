class Micro < Formula
  desc "Modern and intuitive terminal-based text editor"
  homepage "https://github.com/zyedidia/micro"
  url "https://github.com/zyedidia/micro.git",
      :tag      => "v2.0.4",
      :revision => "c5b0c2d41f67048ba859cbf7d7aba6a3b547e1ef"
  head "https://github.com/zyedidia/micro.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4c4855209cf83ee539078f7f7e670e472c981b6813435735a4468c2fe58f7ec7" => :catalina
    sha256 "e6314d36cb44497215dcaca4a42a556488ee94bfc299f8c8589e75ce1955961f" => :mojave
    sha256 "0bcbe418c3a9c4a10af337ab96fe04daa3d1ca6b45b8fb60908c073cf5f700ca" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "micro"
    man1.install "assets/packaging/micro.1"
    prefix.install_metafiles
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/micro -version")
  end
end

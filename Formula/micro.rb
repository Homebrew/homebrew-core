class Micro < Formula
  desc "Modern and intuitive terminal-based text editor"
  homepage "https://github.com/zyedidia/micro"
  url "https://github.com/zyedidia/micro.git",
      :tag      => "v2.0.1",
      :revision => "7c71995aaf56113a0c23f30829f52b43a6d8376e"
  head "https://github.com/zyedidia/micro.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "00bdd2ff110e3ce9f3200b6c4674138409ffe964c018edc7500bc8fb54d0a762" => :catalina
    sha256 "5c363d14693ada72f541daf6a6bc2a470ce3b0dd434996250b4723f44b71af93" => :mojave
    sha256 "413d76c8af75c9647d19d9ab91c5a22f8621a67cb40214cd26085114b34da19d" => :high_sierra
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

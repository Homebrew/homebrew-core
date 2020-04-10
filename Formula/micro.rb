class Micro < Formula
  desc "Modern and intuitive terminal-based text editor"
  homepage "https://github.com/zyedidia/micro"
  url "https://github.com/zyedidia/micro.git",
      :tag      => "v2.0.3",
      :revision => "f59468642dd37c64fc374a9916faaa7cee8b1807"
  head "https://github.com/zyedidia/micro.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "417b185e5ed2f33f4123a8863478c85d468b78aba8fe94941f592a2f54cbfa67" => :catalina
    sha256 "eaee5080d98a9ac30a2131db5a98ca4f9d4ac23b242dc18c70f729a6f5d4f8b1" => :mojave
    sha256 "d9af49d3db91196db9108a56db8a3307c638b62ad0848c4712e231613d64182b" => :high_sierra
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

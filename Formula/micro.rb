class Micro < Formula
  desc "Modern and intuitive terminal-based text editor"
  homepage "https://github.com/zyedidia/micro"
  url "https://github.com/zyedidia/micro.git",
      :tag      => "v2.0.6",
      :revision => "60846f549ccd02598dea5889992f1e4cddc8e86d"
  head "https://github.com/zyedidia/micro.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0cbe6df70d366b8a3528fceb6bbad26308fbb161fed631d54a1ba3bee24ab21c" => :catalina
    sha256 "0dff3972f1cadb4f2f924a572dafd12ddfd1ca2c7f5ee4c7ae88d2221984c2af" => :mojave
    sha256 "3756f21dfd8522b73f16b8c68d9005005d125f132a11940c914f7ff75e5c2b1c" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "make", "build-tags"
    bin.install "micro"
    man1.install "assets/packaging/micro.1"
    prefix.install_metafiles
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/micro -version")
  end
end

class Lf < Formula
  desc "Terminal file manager"
  homepage "https://godoc.org/github.com/gokcehan/lf"
  url "https://github.com/gokcehan/lf/archive/r11.tar.gz"
  sha256 "9b325380b42584b15cf15758d0cc43f23cc697e81546520efe73e7bde8501906"

  bottle do
    cellar :any_skip_relocation
    sha256 "425a8acdb00954e4a13b82cc7090c5d37233b9ee119bea72353633575df956ba" => :mojave
    sha256 "57153e2bdd744e2f81998ec60ae2ce97aaa315d65887efb20ab8d664584a3543" => :high_sierra
    sha256 "cce56f87a135cb5d184fd92419062ab0913b6d8a647a02492cbbcc674f354d98" => :sierra
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["version"] = version
    (buildpath/"src/github.com/gokcehan/lf").install buildpath.children
    cd "src/github.com/gokcehan/lf" do
      system "dep", "ensure", "-vendor-only"
      system "./gen/build.sh", "-o", bin/"lf"
      prefix.install_metafiles
    end
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/lf -version").chomp
    assert_match "file manager", shell_output("#{bin}/lf -doc")
  end
end

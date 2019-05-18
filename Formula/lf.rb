class Lf < Formula
  desc "Terminal file manager"
  homepage "https://godoc.org/github.com/gokcehan/lf"
  url "https://github.com/gokcehan/lf/archive/r12.tar.gz"
  sha256 "8a3ca71dd18ca01f34a08573049c5f9f4302b5c7a998443d2b0855792fdca7f2"

  bottle do
    cellar :any_skip_relocation
    sha256 "425a8acdb00954e4a13b82cc7090c5d37233b9ee119bea72353633575df956ba" => :mojave
    sha256 "57153e2bdd744e2f81998ec60ae2ce97aaa315d65887efb20ab8d664584a3543" => :high_sierra
    sha256 "cce56f87a135cb5d184fd92419062ab0913b6d8a647a02492cbbcc674f354d98" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "on"
    ENV["version"] = version
    (buildpath/"src/github.com/gokcehan/lf").install buildpath.children
    cd "src/github.com/gokcehan/lf" do
      system "./gen/build.sh", "-o", bin/"lf"
      prefix.install_metafiles
    end
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/lf -version").chomp
    assert_match "file manager", shell_output("#{bin}/lf -doc")
  end
end

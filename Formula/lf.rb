class Lf < Formula
  desc "Terminal file manager"
  homepage "https://godoc.org/github.com/gokcehan/lf"
  url "https://github.com/gokcehan/lf/archive/r7.tar.gz"
  sha256 "53cdfac3dc6e8794b1a979ca7f53dda2a3b049ace3892938a2c20ed393bf27dd"

  bottle do
    cellar :any_skip_relocation
    sha256 "10075f60b348ba17a6e4abe63ed4c9a59b9ec3d0d7b0fe241584b8e5673ff91a" => :high_sierra
    sha256 "51263ccfdd0fadb1093bc89719bb55e2b7d1ed56dc4a667d21ea4c8c35e3ac25" => :sierra
    sha256 "c28796e95d3bf98239bae162cd01ea0ea75dd1b090db1301506ba64b58c767b1" => :el_capitan
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

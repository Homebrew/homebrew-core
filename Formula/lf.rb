class Lf < Formula
  desc "Terminal file manager"
  homepage "https://godoc.org/github.com/gokcehan/lf"
  url "https://github.com/gokcehan/lf/archive/r6.tar.gz"
  sha256 "43298a4e391d97643ace9bcb96429a63f9b7a8d321da4b4d36151998abc5cd03"

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

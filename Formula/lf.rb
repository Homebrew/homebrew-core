class Lf < Formula
  desc "Terminal file manager"
  homepage "https://godoc.org/github.com/gokcehan/lf"
  url "https://github.com/gokcehan/lf/archive/r7.tar.gz"
  sha256 "53cdfac3dc6e8794b1a979ca7f53dda2a3b049ace3892938a2c20ed393bf27dd"

  bottle do
    cellar :any_skip_relocation
    sha256 "fff48b734877b86947a30288cc0caecf840ae74ebda3d6ed723a0577a79219c2" => :high_sierra
    sha256 "23ee5f5ee1897e086c4af696b6cb43f619c39f78c89b976363c6409f96bbfe42" => :sierra
    sha256 "9223b0cb384af3ca6df7897d48903b7bf51919ebee573d4c95c8ed6d1f288405" => :el_capitan
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

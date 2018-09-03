class Lf < Formula
  desc "Terminal file manager"
  homepage "https://godoc.org/github.com/gokcehan/lf"
  url "https://github.com/gokcehan/lf/archive/r8.tar.gz"
  sha256 "b92bfba41cc1b4054c44bf615907380482c66694fc9eaf4affe185b39cb9bb26"

  bottle do
    cellar :any_skip_relocation
    sha256 "ef903843e3c9ae32ff3f09158f526b0db1a95f06ec7de56ad63aa1228a5f5260" => :mojave
    sha256 "79c3902898bcfcd00c801c471d6dacaae5aa7ba15c7d8433af53c2e41116e1f0" => :high_sierra
    sha256 "6a3b8a8b61d2470ea28a7d4bcca4755294a85bb89e78764c040d9236665142b2" => :sierra
    sha256 "424581c37cd4cc18da1a7690c9513b837ae4e405d93e3048470ea2aa148c25b5" => :el_capitan
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

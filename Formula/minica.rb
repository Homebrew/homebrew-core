class Minica < Formula
  desc "Small, simple certificate authority"
  homepage "https://github.com/jsha/minica"
  url "https://github.com/jsha/minica/archive/v1.0.0.tar.gz"
  sha256 "30a5b40904ad10999f5641bbf76fcd9503e6d02a7d3b9a713a35e3fd11378f21"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/jsha").mkpath
    ln_s buildpath, buildpath/"src/github.com/jsha/minica"
    system "go", "build", "-o", bin/"minica", "github.com/jsha/minica"
  end

  test do
    system "#{bin}/minica", "--domains", "foo.com"
    assert_predicate testpath/"minica.pem", :exist?
  end
end

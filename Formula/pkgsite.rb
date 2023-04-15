class Pkgsite < Formula
  desc "Command pkgsite runs the pkg.go.dev style docs server"
  homepage "https://github.com/mkraft/pkgsite"
  url "https://github.com/mkraft/pkgsite/archive/refs/tags/v0.0.1.tar.gz"
  sha256 "b9da30c709c081ac14b4261597b8a844c5dcb2262c665520e008a552d46f8446"

  depends_on "go"

  def install
    ENV["PATH"] = "#{ENV["PATH"]}:#{buildpath}/bin"
    system "go", "mod", "vendor"
    (buildpath/"src/github.com/mkraft/pkgsite").install buildpath.children
    cd "src/github.com/mkraft/pkgsite" do
      system "go", "build", "-o", bin/"pkgsite", "./cmd/pkgsite"
    end
  end

  test do
    system bin/"pkgsite", "--help"
  end
end

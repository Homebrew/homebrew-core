class Dunner < Formula
  desc "Task runner tool like Grunt but uses Docker images like CircleCI does"
  homepage "https://github.com/leopardslab/Dunner"
  url "https://github.com/leopardslab/Dunner/archive/v1.0.0.tar.gz"
  sha256 "78837210dc5e3a828f8286a81a2cc995e5f719d8bd00138c4257ee4a55b1d536"
  head "https://github.com/leopardslab/Dunner.git"

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOROOT"] = Formula["go"].opt_libexec
    dir = buildpath/"src/github.com/leopardslab/Dunner"
    dir.install buildpath.children
    cd dir do
      system "dep", "ensure", "-vendor-only"
      system "go", "build", "-o", "dunner"

      bin.install "dunner"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s[0, 5], shell_output("#{bin}/dunner version")
  end
end

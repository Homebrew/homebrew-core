class Lf < Formula
  desc "Terminal file manager"
  homepage "https://godoc.org/github.com/gokcehan/lf"
  url "https://github.com/gokcehan/lf/archive/r14.tar.gz"
  sha256 "5266afa808f4612733af65289024c9eb182864f6a224fdfdf58f405a30c79644"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "a1bdb6f01aa7b75dd2384b6d4b7952503cddb596dfa70b4ab2ea4763bd8cc81c" => :catalina
    sha256 "749e71359f1e380c6ff0eacad07edfc249c4a47ca5243d3dcf528eea6ed3600f" => :mojave
    sha256 "dc2b5d311734cb673eeb301d1733a324f1fa9f0594b796b13896af15370af49e" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["version"] = version
    (buildpath/"src/github.com/gokcehan/lf").install buildpath.children
    cd "src/github.com/gokcehan/lf" do
      system "./gen/build.sh", "-o", bin/"lf"
      prefix.install_metafiles
      man1.install "lf.1"
      zsh_completion.install "etc/lf.zsh" => "_lf"
      fish_completion.install "etc/lf.fish"
    end
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/lf -version").chomp
    assert_match "file manager", shell_output("#{bin}/lf -doc")
  end
end

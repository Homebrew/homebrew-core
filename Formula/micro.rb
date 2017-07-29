class Micro < Formula
  desc "Modern and intuitive terminal-based text editor"
  homepage "https://github.com/zyedidia/micro"
  url "https://github.com/zyedidia/micro/releases/download/v1.3.0/micro-1.3.0-src.tar.gz"
  sha256 "d76c0c849fdd622cdb3ffa4db17244f466ec683dc545188c12f60175747496af"
  head "https://github.com/zyedidia/micro.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "42b621909d3b7b61b41faf322f38f42e0739aa3964008a14686e5cba5e7bf9c3" => :sierra
    sha256 "d601ec47f7deaf7dd8421501feea65ea02bb631a67835cf12f9de7a230184027" => :el_capitan
    sha256 "a250e35d2688835bd858cda94ef5a55ae45ad0d9ba45c39456b04f85e067544c" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    (buildpath/"src/github.com/zyedidia/micro").install buildpath.children

    cd "src/github.com/zyedidia/micro" do
      system "make", "build-quick"
      bin.install "micro"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/micro -version")
  end
end

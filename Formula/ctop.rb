class Ctop < Formula
  desc "Top-like interface for container metrics"
  homepage "https://bcicen.github.io/ctop/"
  url "https://github.com/bcicen/ctop/archive/v0.6.0.tar.gz"
  sha256 "659c87de3d1c4b90d6b481c096d50d799deaf0f591b430606b6f2295862bcbc0"

  bottle do
    cellar :any_skip_relocation
    sha256 "2ac847bd4659f31f4d3685cb9d1b95ade335c600f0fe1850662bf177fa07fe51" => :sierra
    sha256 "6fba466a0a4ca79c719c9a638920186ec1e68a27bed351285bdd7c118b8ebeab" => :el_capitan
    sha256 "f0c5a1a1e1cc7d60314a4f276eb976ff9669ea1a2dfa8dce9d6fea0f0ab08bf7" => :yosemite
  end

  depends_on "go" => :build
  depends_on "glide" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"
    dir = buildpath/"src/github.com/bcicen/ctop"
    dir.install Dir["*"]
    cd dir do
      system "glide", "install"
      system "make", "build"
      bin.install "ctop"
    end
  end

  test do
    system "#{bin}/ctop", "-v"
  end
end

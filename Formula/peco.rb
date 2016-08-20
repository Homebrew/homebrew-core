class Peco < Formula
  desc "Simplistic interactive filtering tool"
  homepage "https://github.com/peco/peco"
  url "https://github.com/peco/peco/archive/v0.4.0.tar.gz"
  sha256 "d04559c04aaf7aab829186e8e977765d8d800ed21a96e0e99c091b90cb7c0f50"
  head "https://github.com/peco/peco.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c8c03e514e10c5d2c6824838a9d8777624f2295ac9d8fc7cca92a5298dcb0b22" => :el_capitan
    sha256 "5b8320b037471270db0c9c1a866c15d00225a2b1b147b74e4bdbb3e696e136db" => :yosemite
    sha256 "ca37bbcdaee4c45e850872b7835128e8ca1e675684e8e5e17d48b790cddca1d0" => :mavericks
  end

  depends_on "glide" => :build
  depends_on "go" => :build

  def go_install(rel = "", options = {})
    ENV["GOPATH"] = buildpath
    using = options[:using]
    rel = Pathname.new(rel)
    proj = Pathname.new(active_spec.url.split("/")[2..4].join("/"))
    proj = proj.dirname/proj.basename(proj.extname)
    dir = buildpath/"src/#{proj}"
    dir.install buildpath.children
    Language::Go.stage_deps resources, buildpath/"src" if using.include? "resources"
    cd dir do
      system "godep", "restore" if using.include? "godep"
      system "glide", "install" if using.include? "glide"
      system "go", "build", "-o", bin/(proj/rel).basename, proj/rel
      prefix.install_metafiles
    end
  end

  def install
    go_install "cmd/peco", :using => "glide"
  end

  test do
    system "#{bin}/peco", "--version"
  end
end

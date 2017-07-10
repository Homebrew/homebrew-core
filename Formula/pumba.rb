class Pumba < Formula
  desc "Chaos testing tool for Docker"
  homepage "https://github.com/gaia-adm/pumba"
  url "https://github.com/gaia-adm/pumba/archive/0.4.4.tar.gz"
  sha256 "fdf11426752c69e79c2db10e2f57ef41c8b5d3d6815602ed11a95402b5db2d35"
  head "https://github.com/gaia-adm/pumba.git"

  depends_on "go" => :build
  depends_on "glide" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"
    ENV["CGO_ENABLED"] = "0"

    (buildpath/"src/github.com/gaia-adm/pumba").install buildpath.children

    cd "src/github.com/gaia-adm/pumba" do
      system "glide", "install", "--strip-vendor"
      system "go", "build", "-o", bin/"pumba", "-ldflags", "-X main.Version=#{version}"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/pumba", "--help"
  end
end

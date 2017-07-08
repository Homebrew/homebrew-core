require "language/go"

class Pumba < Formula
  desc "Chaos testing tool for Docker"
  homepage "https://github.com/gaia-adm/pumba"
  version "0.4.4"
  url "https://github.com/gaia-adm/pumba/archive/0.4.4.tar.gz"
  sha256 "fdf11426752c69e79c2db10e2f57ef41c8b5d3d6815602ed11a95402b5db2d35"
  head "https://github.com/gaia-adm/pumba.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1e0212ac23c68e6bfb126f381a4925a9e29710d63971822070c866892f41142a" => :sierra
  end

  depends_on "go" => :build
  depends_on "glide" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"
    ENV["CGO_ENABLED"] = "0"

    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"
    pumbapath = buildpath/"src/github.com/gaia-adm/pumba"
    pumbapath.install Dir["{*,.git}"]

    ldflags = "-X main.Version=#{version} -X main.GitCommit=4b44337 -X main.GitBranch=master -X main.BuildTime=2017-07-08_09:05_GMTb"

    cd pumbapath do
      system "glide", "install", "-v"
      system "go", "build", "-v", "-o", "dist/pumba", "-ldflags", ldflags
      bin.install "dist/pumba"
    end
  end

  test do
    system "#{bin}/pumba", "--version"
  end
end

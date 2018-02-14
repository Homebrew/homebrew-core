class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.projectcalico.org"
  url "https://github.com/projectcalico/calicoctl.git",
      :tag => "v1.6.1",
      :revision => "1724e011ac0e608190d7d5512ab8028bcd18ae7b"

  bottle do
    cellar :any_skip_relocation
    sha256 "d2e732eab1aee4a1f90f3600435e39c8a63c246bae3e12eb1b806a64c8fa67c2" => :high_sierra
    sha256 "878fd5693b2925e63a43e29a75c3ba548dc9dea979949dc9c4504c2463d7abe4" => :sierra
    sha256 "eaca847212bc19388f185371851f3c90b928c3be521d9abdba1c141bdebc0502" => :el_capitan
  end

  depends_on "glide" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"
    dir = buildpath/"src/github.com/projectcalico/calicoctl"
    dir.install buildpath.children
    cd dir do
      system "glide", "install", "-strip-vendor"
      system "make", "binary"
      bin.install "dist/calicoctl-darwin-amd64" => "calicoctl"
      prefix.install_metafiles
    end
  end

  test do
    system bin/"calicoctl", "--version"
  end
end

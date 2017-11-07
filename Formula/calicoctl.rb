class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.projectcalico.org"
  url "https://github.com/projectcalico/calicoctl.git",
      :tag => "v1.6.1",
      :revision => "1724e011ac0e608190d7d5512ab8028bcd18ae7b"

  depends_on "go" => :build
  depends_on "glide" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"
    pkg_name = "github.com/projectcalico/calicoctl"
    build_dir = buildpath/"src/#{pkg_name}"
    build_dir.install buildpath.children
    cd build_dir do
      system "glide", "install", "-strip-vendor"
      system "make", "binary"
      bin.install "dist/calicoctl-darwin-amd64" => "calicoctl"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/calicoctl", "--version"
  end
end

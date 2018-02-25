class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.projectcalico.org"
  url "https://github.com/projectcalico/calicoctl.git",
      :tag => "v2.0.1",
      :revision => "5fa93655169003652350321d90410ae4dc803d32"

  bottle do
    cellar :any_skip_relocation
    sha256 "450ee82af2dd66cb4345ca6036bdd8c6ec23d1e6abe110e41f3425aab7f369e9" => :high_sierra
    sha256 "1caa63ddd94f829e436dc699b86839bf30f1e7d31fefcb44594af2eae753ad42" => :sierra
    sha256 "c8f7def429b4669bc0b62f9379c2125caa2849cbf1c759d1c9e0140173b06d70" => :el_capitan
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
    assert_match version.to_s, shell_output("#{bin}/calicoctl --version")
  end
end

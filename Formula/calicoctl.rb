class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.projectcalico.org"
  url "https://github.com/projectcalico/calicoctl.git",
      :tag => "v3.1.0",
      :revision => "a09fa70e0c24519356d0b619dc4c931c6e4fa735"

  bottle do
    cellar :any_skip_relocation
    sha256 "b8f1e55d3130b2ed31139a2817c3115547c3353ced86d708172a14dabe2d972b" => :high_sierra
    sha256 "78861d9b05223d20c2f61e58f22afabee6afd4558003e19d1adefa38e13f871d" => :sierra
    sha256 "0045f8f6274b86c72b6795a09ba17d988c7c655e3a7b8ca6ddf211cae69cf2a8" => :el_capitan
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
    assert_match version.to_s, shell_output("#{bin}/calicoctl version", 1)
  end
end

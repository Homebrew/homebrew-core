class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.projectcalico.org"
  url "https://github.com/projectcalico/calicoctl.git",
      :tag => "v3.1.2",
      :revision => "472c0655e73103297fd814533f5dd6c31527e46d"

  bottle do
    cellar :any_skip_relocation
    sha256 "4c95ac500871e2a34dd3e3f883b7e0c2b547a3521b6517535d51a7287e598ae9" => :high_sierra
    sha256 "26be8e07da7fff9a3fe92dfbc09f564f9c37b4723c9c788d6abd33334ce99268" => :sierra
    sha256 "f3374dfd7fd96473c77c2c1ee7dc7c5f30d856c1e1ccdcaca3711cd36239e333" => :el_capitan
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

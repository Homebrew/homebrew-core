class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.projectcalico.org"
  url "https://github.com/projectcalico/calicoctl.git",
      :tag => "v3.1.3",
      :revision => "231083c2ce934b7946ebed3ed96f4fc1a3ba4f69"

  bottle do
    cellar :any_skip_relocation
    sha256 "ab876e7e6816105e303ac1c13c05fd777e5c0ff9b5dd9598f32c83688ed31d4d" => :high_sierra
    sha256 "212809faa0a6f7caf8ac8e622979bdbf1a5aa08871e9d6710c57d68219160ea4" => :sierra
    sha256 "b47a153cf18231d03e4f50043a3a921a1c9c0b895194fe43a803973a854994d7" => :el_capitan
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

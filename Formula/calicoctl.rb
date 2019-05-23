class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.projectcalico.org"
  url "https://github.com/projectcalico/calicoctl.git",
      :tag      => "v3.7.2",
      :revision => "a51fe9153a981102a9b2f901395673cdefa06570"

  bottle do
    cellar :any_skip_relocation
    sha256 "bd8ca7e25ff79bafa1ce29cbc63219cddebec8d79761f76e19e0d134ad097f2a" => :mojave
    sha256 "78f3892314fbe3fdfb4ea870eb2bb7ccad34b0ff86235faa86f2b25f1cd2044c" => :high_sierra
    sha256 "c929f75f5db67d02cb33f95b195802927320ad81d1b09fa6ac0cf5a351c3d5b1" => :sierra
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
      commands = "github.com/projectcalico/calicoctl/calicoctl/commands"
      ldflags = "-X #{commands}.VERSION=#{stable.specs[:tag]} -X #{commands}.GIT_REVISION=#{stable.specs[:revision][0, 8]} -s -w"
      system "go", "build", "-v", "-o", "dist/calicoctl-darwin-amd64", "-ldflags", ldflags, "./calicoctl/calicoctl.go"
      bin.install "dist/calicoctl-darwin-amd64" => "calicoctl"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/calicoctl version", 1)
  end
end

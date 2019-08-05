class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.projectcalico.org"
  url "https://github.com/projectcalico/calicoctl.git",
      :tag      => "v3.8.1",
      :revision => "4059ecd47bc6523050e3b0190b819f2254fca4f0"

  bottle do
    cellar :any_skip_relocation
    sha256 "aae10aaeb52f4d1311a6ee25ee15b6dcf85a1e9a1f5e23b1c8c2170e207b182b" => :mojave
    sha256 "81e65379f0d43cf3894fa38af6a816637af1a1394a9e551e8ce3117eec4a872f" => :high_sierra
    sha256 "9cd21b2c7708426a92378e5227f9af5f810edba6e3e35a7503f1716aa668cb52" => :sierra
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

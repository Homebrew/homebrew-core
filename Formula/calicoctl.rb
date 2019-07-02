class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.projectcalico.org"
  url "https://github.com/projectcalico/calicoctl.git",
      :tag      => "v3.8.0",
      :revision => "c84e9f21ffff58b3c42fb7a65e91c2d946bec60c"

  bottle do
    cellar :any_skip_relocation
    sha256 "11540d057076679aa09cfec1afdbbc3124fbadc1a894152747af20d379972464" => :mojave
    sha256 "3217ecdd877cab638d49357398098f50574c896b3884f61aa952db05d7464744" => :high_sierra
    sha256 "00acb7f161a511303d1013749d5b2e63d8500b589560647fb3e0a95c61af0982" => :sierra
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

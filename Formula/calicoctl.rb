class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.projectcalico.org"
  url "https://github.com/projectcalico/calicoctl.git",
      :tag      => "v3.5.2",
      :revision => "0f3d4af3c263371ed405099b8ebc6dd418822214"

  bottle do
    cellar :any_skip_relocation
    sha256 "f16fc8a7934c3dd46552224353a1a36a5ed1fc9c5265a81e48f1dc4226646b9e" => :mojave
    sha256 "0a050b4fd951cd8cf7593a436fe99571d6e7ce325a2449a12d6168972a1c714c" => :high_sierra
    sha256 "1d8f80446c3395ea05dce58b3ff04f9ec9b5bafee6598c0c5704475e00f1786d" => :sierra
    sha256 "f3c800eb604d967120d6b26897b25a85b2e877d05502baaa17ecd1d8dbbdb24a" => :el_capitan
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

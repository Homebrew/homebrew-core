class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.projectcalico.org"
  url "https://github.com/projectcalico/calicoctl.git",
      :tag      => "v3.8.2",
      :revision => "4059ecd47bc6523050e3b0190b819f2254fca4f0"

  bottle do
    cellar :any_skip_relocation
    sha256 "76a2870f15fa846e11126450da3dcfe312d1e73c2dd2b36b1cbf4578002b8aa7" => :mojave
    sha256 "f5ad5837fe89bdebb9975c88e303858c9f17ea927fff12ada57b9dcd2544d8fc" => :high_sierra
    sha256 "e145176778263e7ad961f58863b308df97146c15e6346ad1fd2febb407f2c2f1" => :sierra
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

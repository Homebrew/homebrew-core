class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.6.1.tar.gz"
  sha256 "af3415f735165aa948f6d40fd03591e22993867828db1370d5717c5e9680dadf"
  head "https://github.com/digitalocean/doctl.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2f22c83c147b1b41e1314eb536be25efe30d51e2422d49eddf4b3964e11398fa" => :sierra
    sha256 "5a1ab4139c45072c59c4a4d94d511ceb440f1f71b51dbbbc82d8deb5436d8ab3" => :el_capitan
    sha256 "bb6558f3e9d72878acbec736e8cc7810d1412d1ebaa0780969b98a7feccf82b4" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    mkdir_p buildpath/"src/github.com/digitalocean/"
    ln_sf buildpath, buildpath/"src/github.com/digitalocean/doctl"

    doctl_version = version.to_s.split(/\./)
    base_flag = "-X github.com/digitalocean/doctl"
    ldflags = %W[
      #{base_flag}.Major=#{doctl_version[0]}
      #{base_flag}.Minor=#{doctl_version[1]}
      #{base_flag}.Patch=#{doctl_version[2]}
      #{base_flag}.Label=release
    ].join(" ")
    system "go", "build", "-ldflags", ldflags, "github.com/digitalocean/doctl/cmd/doctl"
    bin.install "doctl"
  end

  test do
    assert_match "doctl version #{version}-release", shell_output("#{bin}/doctl version")
  end
end

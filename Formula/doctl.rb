require "language/go"

class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.1.0.tar.gz"
  sha256 "c20d130ee3a64d8befbb816702a472469e063b60b75ee41384a66dfd2c97e409"
  head "https://github.com/digitalocean/doctl.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b1afc1456afea8f7481b302ba38346ca9d2c82876516c4ed900bc6f094d0ed83" => :el_capitan
    sha256 "3893acce7fe1592138eab930adeb887acf56fede4765d1abbf6668e4029fd616" => :yosemite
    sha256 "df61c39704a884e835b10b6126aaf442b614fd9152e3028a53a41bdf87ab9da2" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    mkdir_p buildpath/"src/github.com/digitalocean/"
    ln_sf buildpath, buildpath/"src/github.com/digitalocean/doctl"
    Language::Go.stage_deps resources, buildpath/"src"

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
    assert_match "doctl version #{version.to_s}-release", shell_output("#{bin}/doctl version")
  end
end

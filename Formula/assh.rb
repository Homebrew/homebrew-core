class Assh < Formula
  desc "Advanced SSH config - Regex, aliases, gateways, includes and dynamic hosts"
  homepage "https://github.com/moul/advanced-ssh-config"
  url "https://github.com/moul/advanced-ssh-config/archive/v2.4.1.tar.gz"
  sha256 "8867df447e654dae384cf598a81eb6be57a49082449ef4387f33725bb216853c"
  head "https://github.com/moul/advanced-ssh-config.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "28e49700c458e4c8df4e9342a927bc1cbc09877cf762a07d4ee7893b1c47393d" => :sierra
    sha256 "f2a3fa0bc38c3ddc7cf442fbd4114bbc49a4753bbe9963502b46be0825212f19" => :el_capitan
    sha256 "75876951c5bc5706898141f4591fdb1f807ddd6849ae1bd2e75dc3dcdc0baa13" => :yosemite
    sha256 "88a5f8d738264b099333ec4e4fdbcbdf5aada82a3b788a5086b825769036fa23" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/moul/advanced-ssh-config").install Dir["*"]
    cd "src/github.com/moul/advanced-ssh-config/cmd/assh" do
      system "go", "build", "-o", bin/"assh"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/assh --version")
  end
end

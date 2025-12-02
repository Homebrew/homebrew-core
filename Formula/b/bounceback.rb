class Bounceback < Formula
  desc "Stealth redirector for red team operation security"
  homepage "https://github.com/D00Movenok/BounceBack"
  url "https://github.com/D00Movenok/BounceBack/archive/refs/tags/v1.5.2.tar.gz"
  sha256 "3d3f263f8bb7349c25ffa389b98a59858ad4f289cfc03840cb504775fb062f2b"
  license "MIT"
  head "https://github.com/D00Movenok/BounceBack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "056b9bb95bc573c704efb0b1d7a88494adf17812a835afd4f03ce2ca6f14620a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8604b183fd34db0dec18fdf3738f5d10accfe83358355a2ac243d8e484ca99e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8604b183fd34db0dec18fdf3738f5d10accfe83358355a2ac243d8e484ca99e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8604b183fd34db0dec18fdf3738f5d10accfe83358355a2ac243d8e484ca99e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "151b7cc05ca88b9ad080c6be1424ea7418e2e9c39ce024d11c220240555b19a6"
    sha256 cellar: :any_skip_relocation, ventura:       "151b7cc05ca88b9ad080c6be1424ea7418e2e9c39ce024d11c220240555b19a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6030767cf90445f94a88162d2bdd0994af06608b3b52481e36717a164a6c9991"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ddebb59897bab43a8e2b7fcc60b1f2c15b4528fc522e5bb493f391f8659854bd"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/bounceback"

    pkgshare.install "data"
    # update relative data path to homebrew pkg path
    inreplace "config.yml" do |s|
      s.gsub! " data", " #{pkgshare}/data"
    end
    etc.install "config.yml" => "bounceback.yml"
  end

  service do
    run [opt_bin/"bounceback", "--config", etc/"bounceback.yml"]
    keep_alive true
    working_dir var
    log_path var/"log/bounceback.log"
    error_log_path var/"log/bounceback.log"
  end

  test do
    fork do
      exec bin/"bounceback", "--config", etc/"bounceback.yml"
    end
    sleep 2
    assert_match "\"message\":\"Starting proxies\"", (testpath/"bounceback.log").read
    assert_match version.to_s, shell_output("#{bin}/bounceback --help", 2)
  end
end

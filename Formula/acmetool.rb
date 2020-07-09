class Acmetool < Formula
  desc "Automatic certificate acquisition tool for ACME (Let's Encrypt)"
  homepage "https://github.com/hlandau/acmetool"
  url "https://github.com/hlandau/acmetool.git",
      tag:      "v0.0.67",
      revision: "221ea15246f0bbcf254b350bee272d43a1820285"
  license "MIT"
  revision 1

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "859ddcc717399c6724283beece51c0a93497e00be685d3f1cfb7153506cbd9bb" => :catalina
    sha256 "fd6d5e67865a1038fef6f4b183c255e42e4eb6470d5847e804639197f226da6b" => :mojave
    sha256 "62ec2c87880494488a50d78c36104f75eb97bb160ddf316387ab116e51ace2fd" => :high_sierra
  end

  # See: https://community.letsencrypt.org/t/end-of-life-plan-for-acmev1/88430
  deprecate! date: "2020-06-01"

  depends_on "go" => :build
  uses_from_macos "libpcap"

  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/f782e15/acmetool/stable-gomod.diff"
    sha256 "1cd4871cbb885abd360f9060dd660f8e678d1143a182f3bb63bddba84f6ec982"
  end

  def install
    # https://github.com/hlandau/acmetool/blob/221ea15246f0bbcf254b350bee272d43a1820285/_doc/PACKAGING-PATHS.md
    buildinfo = Utils.safe_popen_read("(echo acmetool Homebrew version #{version} \\($(uname -mrs)\\);
                                      go list -m all | sed '1d') | base64 | tr -d '\\n'")
    ldflags = %W[
      -X github.com/hlandau/acme/storage.RecommendedPath=#{var}/lib/acmetool
      -X github.com/hlandau/acme/hooks.DefaultPath=#{lib}/hooks
      -X github.com/hlandau/acme/responder.StandardWebrootPath=#{var}/run/acmetool/acme-challenge
      -X github.com/hlandau/buildinfo.RawBuildInfo=#{buildinfo}
    ].join(" ")

    system "go", "build", "-ldflags", ldflags, "-trimpath", "-o", bin/"acmetool", buildpath/"cmd/acmetool"

    (man8/"acmetool.8").write Utils.safe_popen_read(bin/"acmetool", "--help-man")

    doc.install Dir["_doc/*"]
  end

  def post_install
    (var/"lib/acmetool").mkpath
    (var/"run/acmetool").mkpath
  end

  def caveats
    <<~EOS
      This version is deprecated and will stop working by June 2021. For details, see:
        https://github.com/hlandau/acmetool/issues/322
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/acmetool --version", 2)
  end
end

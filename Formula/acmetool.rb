class Acmetool < Formula
  desc "Automatic certificate acquisition tool for ACME (Let's Encrypt)"
  homepage "https://github.com/hlandau/acmetool"
  url "https://github.com/hlandau/acmetool.git",
      tag:      "v0.0.67",
      revision: "221ea15246f0bbcf254b350bee272d43a1820285"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3a7ca3981353a8c1ce7b022a1734184ca4cb288d8f4dac69af498a5aead925d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa25f92bd3b37f0413f0d372d789c3bc4f611ec04b03a666ed9beb1aea9b2bc4"
    sha256 cellar: :any_skip_relocation, monterey:       "c1f9358896f0c4c6bbfa649c6d7da8601778e78a83f3c5d94ee21b0f0685848e"
    sha256 cellar: :any_skip_relocation, big_sur:        "5f80a75c9eb23177bb4dba1321ec84cee4ebd7a639fb7945c490f85502adfd18"
    sha256 cellar: :any_skip_relocation, catalina:       "91cc3e92638a60e46cc4f003330acea39eb78fe66e5a813e86b96a2b2d43e1e1"
    sha256 cellar: :any_skip_relocation, mojave:         "150d06d622b88104ac60f6eaf914e9c250cc42916e61c94378e1bea58da406bf"
    sha256 cellar: :any_skip_relocation, high_sierra:    "60e99c7778fae7fff51852ade8fb55d679eef47198eb891d59f07a4ccb3e171f"
  end

  # See: https://community.letsencrypt.org/t/end-of-life-plan-for-acmev1/88430
  disable! date: "2022-07-31", because: :deprecated_upstream

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

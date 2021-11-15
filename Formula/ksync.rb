class Ksync < Formula
  desc "Sync files between your local system and a kubernetes cluster"
  homepage "https://ksync.github.io/ksync/"
  url "https://github.com/ksync/ksync.git",
      tag:      "0.4.7-hotfix",
      revision: "14ec9e24670b90ee45d4571984e58d3bff02c50e"
  license "Apache-2.0"
  head "https://github.com/ksync/ksync.git"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a58b20d7cf681598f94c777200474e1419890fb24e3d6217cc0233a91a266bab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4fe9c12efd8e73fd794edecca04b0270e4dc2229adad3953f25635c3432fc313"
    sha256 cellar: :any_skip_relocation, monterey:       "2add85f6b9b1daa3aa4cde7791fec5e36873f2440155c6cb20a1ab08a0be92c7"
    sha256 cellar: :any_skip_relocation, big_sur:        "0e497912738482d6fa2d1161c6a26b62a781b25ba4280f7ac8e2487b757cda9d"
    sha256 cellar: :any_skip_relocation, catalina:       "ccee0b1bd4f7d3af674d1c2901965e7140b4408a794a781fc8e7640276936f98"
    sha256 cellar: :any_skip_relocation, mojave:         "6128a2e80da17e718001cd9a9a240d27b4dcac7a3e893b2e00316b886c04a3d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b5ae17908d10f2c602df06a8a4c03fb92403b11019b9471a3f2d0def2c94376"
  end

  depends_on "go" => :build

  # Support go 1.17, remove after next release
  # Patch is equivalent to https://github.com/ksync/ksync/pull/544,
  # but does not apply cleanly
  patch :DATA

  def install
    project = "github.com/ksync/ksync"
    ldflags = %W[
      -w
      -X #{project}/pkg/ksync.GitCommit=#{Utils.git_short_head}
      -X #{project}/pkg/ksync.GitTag=#{version}
      -X #{project}/pkg/ksync.BuildDate=#{time.rfc3339(9)}
      -X #{project}/pkg/ksync.VersionString=#{tap.user}
      -X #{project}/pkg/ksync.GoVersion=go#{Formula["go"].version}
    ].join(" ")
    system "go", "build", *std_go_args(ldflags: ldflags), "#{project}/cmd/ksync"
  end

  test do
    # Basic build test. Potential for more sophisticated tests in the future
    # Initialize the local client and see if it completes successfully
    expected = "level=fatal"
    assert_match expected.to_s, shell_output("#{bin}/ksync init --local --log-level debug", 1)
  end
end

__END__
diff --git a/go.mod b/go.mod
index e2ff1b7..dd4bed9 100644
--- a/go.mod
+++ b/go.mod
@@ -51,6 +51,7 @@ require (
 	github.com/timfallmk/overseer v0.0.0-20200214205711-64f40ac3a421
 	golang.org/x/crypto v0.0.0-20201016220609-9e8e0b390897
 	golang.org/x/net v0.0.0-20201031054903-ff519b6c9102
+	golang.org/x/sys v0.0.0-20210819135213-f52c844e1c1c // indirect
 	google.golang.org/grpc v1.36.0
 	gopkg.in/ini.v1 v1.52.0 // indirect
 	gopkg.in/resty.v1 v1.12.0
diff --git a/go.sum b/go.sum
index babd1b5..063f1af 100644
--- a/go.sum
+++ b/go.sum
@@ -813,8 +813,9 @@ golang.org/x/sys v0.0.0-20200814200057-3d37ad5750ed/go.mod h1:h1NjWce9XRLGQEsW7w
 golang.org/x/sys v0.0.0-20200930185726-fdedc70b468f/go.mod h1:h1NjWce9XRLGQEsW7wpKNCjG9DtNlClVuFLEZdDNbEs=
 golang.org/x/sys v0.0.0-20201015000850-e3ed0017c211/go.mod h1:h1NjWce9XRLGQEsW7wpKNCjG9DtNlClVuFLEZdDNbEs=
 golang.org/x/sys v0.0.0-20201024232916-9f70ab9862d5/go.mod h1:h1NjWce9XRLGQEsW7wpKNCjG9DtNlClVuFLEZdDNbEs=
-golang.org/x/sys v0.0.0-20201101102859-da207088b7d1 h1:a/mKvvZr9Jcc8oKfcmgzyp7OwF73JPWsQLvH1z2Kxck=
 golang.org/x/sys v0.0.0-20201101102859-da207088b7d1/go.mod h1:h1NjWce9XRLGQEsW7wpKNCjG9DtNlClVuFLEZdDNbEs=
+golang.org/x/sys v0.0.0-20210819135213-f52c844e1c1c h1:Lyn7+CqXIiC+LOR9aHD6jDK+hPcmAuCfuXztd1v4w1Q=
+golang.org/x/sys v0.0.0-20210819135213-f52c844e1c1c/go.mod h1:oPkhp1MJrh7nUepCBck5+mAzfO9JrbApNNgaTdGDITg=
 golang.org/x/text v0.0.0-20160726164857-2910a502d2bf/go.mod h1:NqM8EUOU14njkJ3fqMW+pc6Ldnwhi/IjpwHt7yyuwOQ=
 golang.org/x/text v0.0.0-20170915032832-14c0d48ead0c/go.mod h1:NqM8EUOU14njkJ3fqMW+pc6Ldnwhi/IjpwHt7yyuwOQ=
 golang.org/x/text v0.3.0/go.mod h1:NqM8EUOU14njkJ3fqMW+pc6Ldnwhi/IjpwHt7yyuwOQ=

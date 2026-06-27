class Ksync < Formula
  desc "Sync files between your local system and a kubernetes cluster"
  homepage "https://ksync.github.io/ksync/"
  url "https://github.com/ksync/ksync.git",
      tag:      "0.4.7-hotfix",
      revision: "14ec9e24670b90ee45d4571984e58d3bff02c50e"
  license "Apache-2.0"
  head "https://github.com/ksync/ksync.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "1620949d8da595167314a38d77d648496ae8f643d95b41020ac84618cbc341a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a3552681fcab8cb7f7dfe63812571245c0da18d06393a41bf561f9e812342085"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "270b540aa1ca3ebc1986174383b922ca0c6d8638f86b782bf7f1318d5f537574"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "728e06453e95f4ec8cc1e96f0f9c3f651595dd2c23e72e9ed755fef4c3d87031"
    sha256 cellar: :any_skip_relocation, sonoma:         "d2af057006526b92353cb99608b2cb06565b9a08d3e72783d33a948df7c031ed"
    sha256 cellar: :any_skip_relocation, ventura:        "d3aa2e52fe35f59dc31ce6b1db46f74d8212b2f266c0255a6c28e3752a7dc79b"
    sha256 cellar: :any_skip_relocation, monterey:       "45a3f6d24f45ff5b154e4729d7ebd9017c8c328c5a991c9e1c9def407c84fc53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8252f654f5d54ab8b359866a358f2e439c7dcc2f061c8330fe42917a5b00724e"
  end

  # no release since 2021-03-23, https://github.com/ksync/ksync/issues/616
  deprecate! date: "2024-08-02", because: :unmaintained
  disable! date: "2025-08-03", because: :unmaintained

  depends_on "go@1.22" => :build

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
      -X #{project}/pkg/ksync.BuildDate=#{time.iso8601(9)}
      -X #{project}/pkg/ksync.VersionString=#{tap.user}
      -X #{project}/pkg/ksync.GoVersion=go#{Formula["go"].version}
    ]
    system "go", "build", *std_go_args(ldflags:), "#{project}/cmd/ksync"
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

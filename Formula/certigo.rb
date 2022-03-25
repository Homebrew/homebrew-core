class Certigo < Formula
  desc "Utility to examine and validate certificates in a variety of formats"
  homepage "https://github.com/square/certigo"
  url "https://github.com/square/certigo/archive/v1.15.1.tar.gz"
  sha256 "1c6b336a33fd944dfa1b05d3b592261d7538333a605078bdbb9889bbab088f0a"
  license "Apache-2.0"
  head "https://github.com/square/certigo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a20db55da154743cd0f57a0359533da0bbf8d762426ba8d10b547e7f458fe32"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "074297e95f91799d2e25ae3aba6f547ebb886764b2d1665532b02a8cc978025c"
    sha256 cellar: :any_skip_relocation, monterey:       "ae6f45a1b334a78c92e955a3a4851b77b51898f670061ad5fd7ed5b3c23f9972"
    sha256 cellar: :any_skip_relocation, big_sur:        "b2b5e65ddd7ae1809d446c3bad3faa2efd95e612e642dc763a8e808f99bb6c49"
    sha256 cellar: :any_skip_relocation, catalina:       "f2c30110fe0945517cf01dcc5e520e8b9d1a53380da65e31c18d66bec9c78bd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87f468be2c761450fcd66157e0ea411912a910f35b13bafec3ee46bea8f86194"
  end

  depends_on "go" => :build

  def install
    system "./build"
    bin.install "bin/certigo"

    # Install bash completion
    output = Utils.safe_popen_read("#{bin}/certigo", "--completion-script-bash")
    (bash_completion/"certigo").write output

    # Install zsh completion
    output = Utils.safe_popen_read("#{bin}/certigo", "--completion-script-zsh")
    (zsh_completion/"_certigo").write output
  end

  test do
    (testpath/"test.crt").write <<~EOS
      -----BEGIN CERTIFICATE-----
      MIIDLDCCAhQCCQCa74bQsAj2/jANBgkqhkiG9w0BAQsFADBYMQswCQYDVQQGEwJV
      UzELMAkGA1UECBMCQ0ExEDAOBgNVBAoTB2NlcnRpZ28xEDAOBgNVBAsTB2V4YW1w
      bGUxGDAWBgNVBAMTD2V4YW1wbGUtZXhwaXJlZDAeFw0xNjA2MTAyMjE0MTJaFw0x
      NjA2MTEyMjE0MTJaMFgxCzAJBgNVBAYTAlVTMQswCQYDVQQIEwJDQTEQMA4GA1UE
      ChMHY2VydGlnbzEQMA4GA1UECxMHZXhhbXBsZTEYMBYGA1UEAxMPZXhhbXBsZS1l
      eHBpcmVkMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAs6JY7Hm/NAsH
      3nuMOOSBno6WmwsTYEw3hk4eyprWiI/NpoiaiZVCGahT8NAKqLDW5t9vgKz6c4ff
      i5/aQ2scichq3QS7pELAYlS4b+ey3dA6hj62MOTTO4Ad5bFbbRZG+Mdm2Ayvl6eV
      6catQhMvxt7aIoY9+bodyIYC1zZVqwQ5sOT+CPLDnxK+GvhoyD2jL/XwZplWiIVL
      oX6eEpKIo/QtB6mSU216F/PuAzl/BJond+RzF9mcxJjdZYZlhwT8+o8oXEMI4vEf
      3yzd+zB/mjuxDJR2iw3bSL+zZr2GV/CsMLG/jmvbpIuyI/p5eTy0alz+iHOiyeCN
      9pgD6jyonwIDAQABMA0GCSqGSIb3DQEBCwUAA4IBAQAMUuv/zVYniJ94GdOVcNJ/
      bL3CxR5lo6YB04S425qsVrmOex3IQBL1fUduKSSxh5nF+6nzhRzRrDzp07f9pWHL
      ZHt6rruVhE1Eqt7TKKCtZg0d85lmx5WddL+yWc5cI1UtCohB9+iZDPUBUR9RcszQ
      dGD9PmxnPc9soEcQw/3iNffhMMpLRhPaRW9qtJU8wk16DZunWR8E0Oeq42jVTnb4
      ZiD1Idajj0tj/rT5/M1K/ZLEiOzXVpo/+l/+hoXw9eVnRa2nBwjoiZ9cMuGKUpHm
      YSv7SyFevNwDwcxcAq6uVitKi0YCqHiNZ7Ye3/BGRDUFpK2IASUo8YbXYNyA/6nu
      -----END CERTIFICATE-----
    EOS
    system bin/"certigo", "dump", "test.crt"
  end
end

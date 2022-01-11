class Certigo < Formula
  desc "Utility to examine and validate certificates in a variety of formats"
  homepage "https://github.com/square/certigo"
  url "https://github.com/square/certigo/archive/v1.14.1.tar.gz"
  sha256 "3ed30adc63869fcbded9bff51e07eaadb08c243980ee08f18858cb6c2a86d232"
  license "Apache-2.0"
  head "https://github.com/square/certigo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d58d141ec797642a5328639290a50e8af1aab185a38c36be13d4a5e8c7aa0a6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cbb97e3b924fe9c0074b14c885682c3eec696ded881a65db17af607bfeb85c97"
    sha256 cellar: :any_skip_relocation, monterey:       "b11198a9086c6959be63a5fa0eefa0bc563f013868645a70e7d2a65296949acc"
    sha256 cellar: :any_skip_relocation, big_sur:        "00a50c8b17d3484987e4aa679b625be5717eda1acead9f4f1e316dc334b04686"
    sha256 cellar: :any_skip_relocation, catalina:       "d2e94552ffeb15738fa23d6e03a86908fe2ff2487cb9dc787706ecaf1558b01f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7ea2e7180a7de46d7fcf6cba8027fb8a86b89abf088102ecdd9182224155619"
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

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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c821ed50edeca5b1f5f96859966f2e4cc71ca2106f0ac9e9a22c8504c1eba420"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "af820a9dc6ea3aaafffc292931dcbbb55281efe6976585bb7a41912a3a4761f5"
    sha256 cellar: :any_skip_relocation, monterey:       "e7b90757c3d6386fbe28a530057cb7e2a211f86f263937622c8107e144585867"
    sha256 cellar: :any_skip_relocation, big_sur:        "4aa9d2923c6e73524a573d64f5bd5325e86fe8f64907de52ac59cd4ffbad8eea"
    sha256 cellar: :any_skip_relocation, catalina:       "850ae90eeb9960c1152cd35c6ab2a431123ddbc5380241f8a460a5a4bac1597e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef25a6de0f2ee9a786355247f7ed7d942f9fb8711ee721e0ac11337b9bd970bc"
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

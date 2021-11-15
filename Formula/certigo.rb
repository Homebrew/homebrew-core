class Certigo < Formula
  desc "Utility to examine and validate certificates in a variety of formats"
  homepage "https://github.com/square/certigo"
  url "https://github.com/square/certigo/archive/v1.12.1.tar.gz"
  sha256 "800bdfa10ffc7f6313397220d02769e88ed5dae001224c9f0199383dcb63eaec"
  license "Apache-2.0"
  head "https://github.com/square/certigo.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ac932347dec1e09093d3799c5ab81be7c8771bf8f65f336c05be410318d166d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9761910b65d0cd920c2f78f3cc3a3231461b15f24f3467d70599bd1398368654"
    sha256 cellar: :any_skip_relocation, monterey:       "ac22fd7bc83b5780053742d528645946ea585e9cfbd5c3475a228183ab60566d"
    sha256 cellar: :any_skip_relocation, big_sur:        "c2f92814d6ab9339a0e5cf6d1489d92577f9fb422538d3a374c5e24ac7e78459"
    sha256 cellar: :any_skip_relocation, catalina:       "9cb3d249c87ed65409a4e4a0e7841bbb8ab9192dea06df8f78f28f0fcbec4550"
    sha256 cellar: :any_skip_relocation, mojave:         "85d39ea2806bbd5ea750486132343d2dc36d5cc37ac0048d4561c40d20826fde"
    sha256 cellar: :any_skip_relocation, high_sierra:    "0ec7c22fe619af5e5178f4387f2731909ff02d4379ec62784f3625d2a63c358c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "917a031d006d106895ca2da9894087129f9f9d7e58ae11c7c7e49427a433f1be"
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

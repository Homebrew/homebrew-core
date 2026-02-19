class Certigo < Formula
  desc "Utility to examine and validate certificates in a variety of formats"
  homepage "https://github.com/square/certigo"
  url "https://github.com/square/certigo/archive/refs/tags/v1.17.1.tar.gz"
  sha256 "4ac183d25d89246519cce0c7d3ed3e3be261ac72f4ed3b15b9e0690c91778ed4"
  license "Apache-2.0"
  head "https://github.com/square/certigo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f8ac461d690d136c9732b38b3aed77b6ee45044facc3bff02c8c1ab10c9da38d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "178bf6b7f2d571b80251d754e9d1103940ece8b33cb89660973bbae84d0e376c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e8007c62003b39a369bb73c7768c22d92b66ff8615ea03218db7cd7b513ee25"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "90657fc29a0515bac14c9386da4f44941322a733c99d39553cb70679246e561a"
    sha256 cellar: :any_skip_relocation, sonoma:        "af2deb051e563fb696a4d9eabbb2b048264d0039502f3b06497d374031205e9a"
    sha256 cellar: :any_skip_relocation, ventura:       "0d9f5fa9aa9d3f134bb7fc49847e3527f5d3cdc256b8a6aefe6f004e183e6693"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4386ccf3e4676d87da7bf027d5eadc56eb40bf7fe9bfd000643b442a14235b9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6cd101ccf0fc12278a68a8c7de6fb9d0f24b7230bc9a4b81a5f5e642cc8f245"
  end

  depends_on "go" => :build

  def install
    system "./build"
    bin.install "bin/certigo"

    generate_completions_from_executable(bin/"certigo", shell_parameter_format: "--completion-script-",
                                                        shells:                 [:bash, :zsh])
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

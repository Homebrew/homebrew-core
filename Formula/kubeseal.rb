class Kubeseal < Formula
  desc "Kubernetes controller and tool for one-way encrypted Secrets"
  homepage "https://github.com/bitnami-labs/sealed-secrets"
  url "https://github.com/bitnami-labs/sealed-secrets.git",
      tag:      "v0.19.1",
      revision: "5ad819f159c898aee74739ef11741beb6d428445"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7003d7152281e9ae9625d02327514fa0e0813f91500c3562de192124a4d9d528"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fdae996989c7cdae34c789eb44959e7c6342c4944dc3195e5cbdafc95898d7e3"
    sha256 cellar: :any_skip_relocation, monterey:       "3462ea3cc859c72e4d3f84e564607fe77358bf8c01adc6440135233f91a84ca3"
    sha256 cellar: :any_skip_relocation, big_sur:        "6517cb9df550ee52a4258b8eea69731d59175109be24010a0840be61f589d33a"
    sha256 cellar: :any_skip_relocation, catalina:       "1864a12e8f5f60ff8722a7ed224c2e51926ad5e9ecb4d4343bcbc870cf2e1de7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01505fa5b8a143e8988c68acb265fd27db586caecd257f449104f2af3b4c0407"
  end

  depends_on "go" => :build

  def install
    system "make", "kubeseal", "DIRTY="
    bin.install "kubeseal"
  end

  test do
    # ensure build reports the (git tag) version
    output = shell_output("#{bin}/kubeseal --version")
    assert_equal "kubeseal version: v#{version}", output.strip

    # ensure kubeseal can seal secrets
    secretyaml = [
      "apiVersion: v1",
      "kind: Secret",
      "metadata:",
      "  name: mysecret",
      "  namespace: default",
      "type: Opaque",
      "data:",
      "  username: YWRtaW4=",
      "  password: MWYyZDFlMmU2N2Rm",
    ].join("\n") + "\n"
    cert = [
      "-----BEGIN CERTIFICATE-----",
      "MIIErTCCApWgAwIBAgIQKBFEtKBDXcPklduZRLUirTANBgkqhkiG9w0BAQsFADAA",
      "MB4XDTE4MTEyNzE5NTE0NloXDTI4MTEyNDE5NTE0NlowADCCAiIwDQYJKoZIhvcN",
      "AQEBBQADggIPADCCAgoCggIBALff4ul8nqD+5mdaeFOJWzhah8v+AJeXZ2Ko4cBZ",
      "5PCWvbFQKAO+o2GwEZsUHaxP31eeUIAt0L/SjxaT9usoXK8QbtwRBV39H6iLI48+",
      "DP2v9AnZgN7G87lyqDufy5IdRyeYh0naTc9C8jWwoG8rDYR85Jxf+M/9grLb2yeD",
      "hAj+ziPTBr3t4hle/ob6pUUNh5I2rnoIT9lrCaRLTOhJqYofL4ld9ikDdCR0h2W9",
      "ZZCb9MnYNohng/7KCRWeyPEs+pDs5XiDCn4m4ObL4JJDhS4uIUiY0jstlN74wRul",
      "BZzn3WpjpDSLNa6wTpf/o91UplBUDEr9eWWsfGcgAw5iuKM46uWX7sAWQg65CqT3",
      "oR9JMJIRvNKbTEMfXRAIw0Imrox5E9B1uv3tCowFY4zQRNFUnEcCOonyOXGyVP8V",
      "gLMA+2f1vGyFYXjbPyC8dR/JZzUf9t+PfhitIU6eNjmeF5s319n0kfiC4e+/38Dv",
      "QN/uZ9MgUfa5pVcLKtX83Zu6vrNDOJT0iFil/WqHqo7BCtfAPX2o/2iXDhZDtcIV",
      "AafIu9HIuldEeAmfp7zAkFQEG+boL54kHsrvTljDkxHvl39eJuFqvZVdJAXcCVfO",
      "KyXyAdDk11XVhCyGMu93L7tffsmVVqgVcXU/vKupqjag/+xDTfRPhHCM1FrDMA7e",
      "ghuLAgMBAAGjIzAhMA4GA1UdDwEB/wQEAwIAATAPBgNVHRMBAf8EBTADAQH/MA0G",
      "CSqGSIb3DQEBCwUAA4ICAQATIoPga81tw0UQpPsGr+HR7pwKQTIp4zFFnlQJhR8U",
      "Kg1AyxXfOL+tK28xfTnMgKTXIcel+wsUbsseVDamJDZSs4dgwZFDxnV76WhbP67a",
      "XP1wHuu6H9PAt/NKV7iGpBL85mg88AlmpPYX5P++Pk5h+i6CenVFPDKwVHDc0vTB",
      "z4yO7MJmSmvGAkjAjmU0s37t3wfWyQpgID8uZmKNbvH8Ie0Y/fSuHz42HMOtb1SI",
      "5ck8jVpQgJwpfNVAy9fwwdyCdKKEGyGmo8oPYAT5Y9GFZh8dqoqVqATwJqLUe//V",
      "OEDxoRV+BXesbpJbJ8tOVtBHzoDU+tjx1jTchf2iWOPByIRQYNBvk25UWNnkdFLy",
      "f9PDrMo6axh+kjQTqrJ4JChL9qHXwSjTshaEcR272xD4vuRX+VMstQqRPwVElRnf",
      "o+MQ5YUiwulFnSykR5zY0U1jGdjywOzxRDLHsPo1WWnOuzfcHarM+YoMDnFzrOzJ",
      "EwP0zIygDpFytgh+Uq+ypKav7CHdA/yy/eWjDJI8b6gKB3mDB5pF+0KtBV61kbfF",
      "7+dVEtF0wQK+0CUdFtFRv3sk5Ud6wHrvMVTY7I4UcHVBe08DhrNJujHzTjolfXTj",
      "s0IweLRbZLe3m/9JLdW6WxylJSUBJhFJGASNwiAm9FwlwryLXzsjNHV/8Y6NkEnf",
      "JQ==",
      "-----END CERTIFICATE-----",
    ].join("\n") + "\n"

    File.write("cert.pem", cert)
    pipe_output("#{bin}/kubeseal --cert cert.pem", secretyaml)
  end
end

class Kubeseal < Formula
  desc "Kubernetes controller and tool for one-way encrypted Secrets"
  homepage "https://github.com/bitnami-labs/sealed-secrets"
  url "https://github.com/bitnami-labs/sealed-secrets.git",
      tag:      "v0.37.0",
      revision: "8e4ed463552a6a6462648a9ff090a1f42abbda30"
  license "Apache-2.0"
  head "https://github.com/bitnami-labs/sealed-secrets.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "615483f985d6aa777e8e7a59fcec59aed545e1d77787954b82e8f9bccd6b7dff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73695f5e8c4d38faad863e351482acd943461ae2ecf660b2ad5cef27fe7a20aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0bc0c905a364e8552c9320561de5a5430fd5e40ff42884ea092c09589c4ab770"
    sha256 cellar: :any_skip_relocation, sonoma:        "e7bfcc073169d35891529f6e1465c2e55d3747592ef764778b4ba9b88049cbc0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34e55d0960fc0e015dcfc5ee8bf920d159fa556efa82801175d23c914860423d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1028eea00dfb120cb25a2c242ae0851531a330767b712c1292b3c6a30a2764a1"
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

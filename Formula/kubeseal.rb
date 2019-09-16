class Kubeseal < Formula
  desc "Kubernetes controller and tool for one-way encrypted Secrets"
  homepage "https://github.com/bitnami-labs/sealed-secrets"
  url "https://github.com/bitnami-labs/sealed-secrets.git",
      :tag      => "v0.8.3",
      :revision => "ec80fcecfe8b29cb13535c242337d79b18a14072"
  sha256 "753f9084a0bf5dfccfe84dff036e87b899a3be921c1d33a497a4b44ac582f00d"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "f98d8afa284cebac24d5713067dab12a7d152fb1a5166c2dad82a9d54d91f857" => :mojave
    sha256 "62592eec33506876e1a6be01dbb7c4b9ecc988cc31643859a42d95a699845303" => :high_sierra
    sha256 "d8ccc5d5ba1de5bb00e00d6dafc1c8a2c46bb2cde0ef8b7f7c9aa77b1181c96d" => :sierra
  end

  depends_on "go" => :build

  def install
    cd buildpath do
      system "make", "kubeseal"
      bin.install "kubeseal"
    end
  end

  test do
    # ensure build reports the (git tag) version
    output = shell_output("#{bin}/kubeseal --version")
    assert_equal "kubeseal version: v0.8.3", output.strip

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

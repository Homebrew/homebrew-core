class Mktxp < Formula
  include Language::Python::Virtualenv

  desc "Prometheus Exporter for Mikrotik RouterOS devices"
  homepage "https://github.com/akpw/mktxp"
  url "https://files.pythonhosted.org/packages/be/5b/5121c732c982091ef67aa08a86e46134d504bd403f4e72928d0b4bbb1404/mktxp-2.1.1.tar.gz"
  sha256 "50f9f821f567c223738e3892bf8e7ca7e2642e3427c5e2031f21fc2fe47fe884"
  license "GPL-2.0-or-later"

  bottle do
    manifest_sha256 "d9b90b0b58ef2983ca37df340a5bfddd671eb9540f2ccc785f04b5b7cdce9b33"
    sha256 cellar: :any, arm64_golden_gate: "40424e2a7406c1c62ff360497897aee531e62b0d8250d744748fc493f7e2db18"
    sha256 cellar: :any, arm64_tahoe:       "8a8066bcd9e351c322eadf35c1cd7ffc238c6eadcaed192594ef78f31040c475"
    sha256 cellar: :any, arm64_sequoia:     "293a8041475e5290fee3bd5b10d1d39a3fe1e8b613fd22cb381b03a4fd7c48cf"
    sha256 cellar: :any, arm64_linux:       "b67fcf7e67639566bfb3793eb8495608852f7a37cbcf69dce0cf32e9cff82f70"
    sha256 cellar: :any, x86_64_linux:      "e31c36cef084b81cc2ec47fd5dd876897a57d819f711ddb79234a5279a45bf1e"
  end

  depends_on "libyaml"
  depends_on "python@3.15"

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/f5/c4/c7f9e41bc2e5f8eeae4a08a01c91b2aea3dfab40a3e14b25e87e7db8d501/configobj-5.0.9.tar.gz"
    sha256 "03c881bbf23aa07bccf1b837005975993c4ab4427ba57f959afdd9d1a2386848"
  end

  resource "humanize" do
    url "https://files.pythonhosted.org/packages/d0/a7/5391f6db94bf16289ca63ce2632eef2eba7b9991e701016ac66f04539d47/humanize-4.17.0.tar.gz"
    sha256 "1d6a36c453dbfbb3f0b34601d2e0b4ce5d48d780305cd45714843f0068fde6ac"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/c3/75/ffb1dc0ed12352139fb4ca0e3fde4325a23e3d0f3f40efe89717bc4f557b/packaging-26.4.tar.gz"
    sha256 "c4b671c41ddb9bf26e543c37723610d28fb6bf7affc4da17cf048d419d2c062a"
  end

  resource "prometheus-client" do
    url "https://files.pythonhosted.org/packages/52/73/f1334c29c2af4cd9dba6c7817e61b611bd0215e2eb5565c6064a4de18802/prometheus_client-0.26.0.tar.gz"
    sha256 "04a91bcf94e2cf74a44a1a874d651a2e853ed354b6e822f3b7487751465d5c2b"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/76/b8/c0b780928e2fb1c87e9e375818c6f121da2398b071012d1747be300b83f4/pyyaml-6.0.4.tar.gz"
    sha256 "e24bf71af8a432d7808fabff134d38dfe16d3cbb41f2873bb4b1e42422de0a1a"
  end

  resource "routeros-api" do
    url "https://files.pythonhosted.org/packages/3b/3d/414cfbdc91ca6cf127cde120178ec0961caec4b1810e654f2d4520a475b7/routeros_api-0.21.0.tar.gz"
    sha256 "0d37452a4ff85cd476dca392068d7d76ba430c9b055c39d8dabc5930a997d82d"
  end

  resource "speedtest-cli" do
    url "https://files.pythonhosted.org/packages/85/d2/32c8a30768b788d319f94cde3a77e0ccc1812dca464ad8062d3c4d703e06/speedtest-cli-2.1.3.tar.gz"
    sha256 "5e2773233cedb5fa3d8120eb7f97bcc4974b5221b254d33ff16e2f1d413d90f0"
  end

  resource "texttable" do
    url "https://files.pythonhosted.org/packages/92/f2/2d43e9505895dc66929a26a46d89c7e96835aff72a28ec5ef54d6e96ee24/texttable-1.7.3.tar.gz"
    sha256 "ff99aa7562c6cbcd0982cb6fae9145126b19878182496cdc46b8d6816721c5da"
  end

  resource "waitress" do
    url "https://files.pythonhosted.org/packages/bf/cb/04ddb054f45faa306a230769e868c28b8065ea196891f09004ebace5b184/waitress-3.0.2.tar.gz"
    sha256 "682aaaf2af0c44ada4abfb70ded36393f0e307f4ab9456a215ce0020baefc31f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mktxp info")

    assert_match "Sample-Router", shell_output("#{bin}/mktxp --cfg-dir #{testpath} show")
  end
end

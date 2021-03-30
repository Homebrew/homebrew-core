class Codesync < Formula
  include Language::Python::Virtualenv

  desc "Sync your code changes as you make them"
  homepage "https://www.codesync.com"
  url "https://github.com/codesyncapp/codesync/archive/refs/tags/v1.0.tar.gz"
  sha256 "666cd7cc487e27fc0126840a68161318b98014fe5ea333ed97ab615ff11bf46e"

  license "MIT"

  depends_on "python@3.9"

  resource "diff-match-patch" do
    url "https://files.pythonhosted.org/packages/f0/1e/48ba888757d3f63ff35536e3e73e05c8a20d701e2b4fcbe4b17c29a2408d/diff-match-patch-20200713.tar.gz"
    sha256 "da6f5a01aa586df23dfc89f3827e1cafbb5420be9d87769eeb079ddfd9477a18"
  end

  resource "humanize" do
    url "https://files.pythonhosted.org/packages/64/f1/2fb00b5db6ece093d47fa8d0afc0634683c06bc8f0d0dd2a2457905d8456/humanize-3.2.0.tar.gz"
    sha256 "ab69004895689951b79f2ae4fdd6b8127ff0c180aff107856d5d98119a33f026"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/b7/64/e097eea8dcd2b2f7df6e4425fc98e7494e37b1a6e149603c31d327080a05/pathspec-0.8.1.tar.gz"
    sha256 "86379d6b86d75816baba717e64b1a3a3469deb93bb76d613c9ce79edc5cb68fd"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/be/ed/5bbc91f03fa4c839c4c7360375da77f9659af5f7086b7a7bdda65771c8e0/python-dateutil-2.8.1.tar.gz"
    sha256 "73ebfe9dbf22e832286dafa60473e4cd239f8592f699aa5adaf10050e6e1823c"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/a0/a4/d63f2d7597e1a4b55aa3b4d6c5b029991d3b824b5bd331af8d4ab1ed687d/PyYAML-5.4.1.tar.gz"
    sha256 "607774cbba28732bfa802b54baa7484215f530991055bb562efbed5b2f20a45e"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/40/a7/ded59fa294b85ca206082306bba75469a38ea1c7d44ea7e1d64f5443d67a/certifi-2020.6.20.tar.gz"
    sha256 "5930595817496dd21bb8dc35dad090f1c2cd0adfaf21204bf6732ca5d8ee34d3"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ea/b7/e0e3c1c467636186c39925827be42f16fee389dc404ac29e930e9136be70/idna-2.10.tar.gz"
    sha256 "b307872f855b18632ce0c21c5e45be78c0ea7ae4c15c828c20788b26921eb3f6"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/6b/47/c14abc08432ab22dc18b9892252efaf005ab44066de871e72a38d6af464b/requests-2.25.1.tar.gz"
    sha256 "27973dd4a904a4f13b263a19c866c13b92a39ed1c964655f025f3f8d3d75b804"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/81/f4/87467aeb3afc4a6056e1fe86626d259ab97e1213b1dfec14c7cb5f538bf0/urllib3-1.25.10.tar.gz"
    sha256 "91056c15fa70756691db97756772bb1eb9678fa585d9184f24534b100dc60f4a"
  end

  resource "websocket_client" do
    url "https://files.pythonhosted.org/packages/8b/0f/52de51b9b450ed52694208ab952d5af6ebbcbce7f166a48784095d930d8c/websocket_client-0.57.0.tar.gz"
    sha256 "d735b91d6d1692a6a181f2a8c9e0238e5f6373356f561bb9dc4c7af36f452010"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/d4/59/9da0e01fbf674321c7d185176173d4aead772086c1f793dc0b23697b1f76/boto3-1.17.20.tar.gz"
    sha256 "2219f1ebe88d266afa5516f993983eba8742b957fa4fd6854f3c73aa3030e931"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/2b/92/72397a4c5ffa3f74525f6abed9116230e4069fab1149917b0811e2a1f7b2/botocore-1.20.21.tar.gz"
    sha256 "b604bbda4205b1a463c20d8434c7ddce1abbc3f6a4d5bf911e2b7774b2807f03"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/3c/56/3f325b1eef9791759784aa5046a8f6a1aff8f7c898a2e34506771d3b99d8/jmespath-0.10.0.tar.gz"
    sha256 "b85d0567b8666149a93172712e68920734333c0ce7e89b78b3e987f71e5ed4f9"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/08/e1/3ee2096ebaeeb8c186d20ed16c8faf4a503913e5c9a0e14cd6b8ffc405a3/s3transfer-0.3.4.tar.gz"
    sha256 "7fdddb4f22275cf1d32129e21f056337fd2a80b6ccef1664528145b72c49e6d2"
  end

  def install
    virtualenv_install_with_resources
  end

  plist_options startup: "true"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <true/>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{bin}/codesync</string>
          <string>-rd</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>StandardErrorPath</key>
        <string>/var/log/codesync.log</string>
        <key>StandardOutPath</key>
        <string>/var/log/codesync.log</string>
      </dict>
      </plist>
    EOS
  end

  test do
    system "#{bin}/codesync", "--help"
  end
end

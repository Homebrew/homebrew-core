class Aerleon < Formula
  include Language::Python::Virtualenv

  desc "Generate firewall configs for multiple firewall platforms"
  homepage "https://aerleon.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/b8/e5/f4386abc5d0e7f18bba22650514c1c14dbd235c93e11ac020f6c724614da/aerleon-1.7.0.tar.gz"
  sha256 "f3145c2a04f37c0463fbd80ee650f039bda9bc445e9c7fd4f18d8eeeda1b6ead"
  license "Apache-2.0"
  head "https://github.com/aerleon/aerleon.git", branch: "main"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fba986d48e2660f0793902161dc340033826988687368e54d167ad2582ff87ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "443e4869b384088b7480b71abd487a6e8f484cd580d142e7b7d6591e5794c21e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed35df34125322a1889008e522566e49bd4df831995e9d02e0324b22dc22ac6b"
    sha256 cellar: :any_skip_relocation, sonoma:         "36a528a249ac51e197317878fcbd43a4359609c40d0263541778d153f25afa19"
    sha256 cellar: :any_skip_relocation, ventura:        "a964f0a88b90962658c81534496e9c7029aa9dae5f46d6e9494b45447dde1f95"
    sha256 cellar: :any_skip_relocation, monterey:       "944212093a588cc6ab9e63da9535e35e8ec509fbd73d378409ed971e0caa3bbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69a6fe0fb1e645c0ec2e374706bc4ce95ced0fad09c03a3ca2bd12093ebd6598"
  end

  depends_on "python@3.12"

  resource "absl-py" do
    url "https://files.pythonhosted.org/packages/79/c9/45ecff8055b0ce2ad2bfbf1f438b5b8605873704d50610eda05771b865a0/absl-py-1.4.0.tar.gz"
    sha256 "d2c244d01048ba476e7c080bd2c6df5e141d211de80223460d5b3b8a2a58433d"
  end

  resource "ply" do
    url "https://files.pythonhosted.org/packages/e5/69/882ee5c9d017149285cab114ebeab373308ef0f874fcdac9beb90e0ac4da/ply-3.11.tar.gz"
    sha256 "00c7c1aaa88358b9c765b6d3000c6eec0ba42abca5351b095321aef446081da3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/0c/1d/eb26f5e75100d531d7399ae800814b069bc2ed2a7410834d57374d010d96/typing_extensions-4.9.0.tar.gz"
    sha256 "23478f88c37f27d76ac8aee6c905017a143b0b1b886c3c9f66bc2fd94f9f5783"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"def/definitions.yaml").write <<~EOS
      networks:
        RFC1918:
          values:
            - address: 10.0.0.0/8
            - address: 172.16.0.0/12
            - address: 192.168.0.0/16
        WEB_SERVERS:
          values:
            - address: 10.0.0.1/32
              comment: Web Server 1
            - address: 10.0.0.2/32
              comment: Web Server 2
        MAIL_SERVERS:
          values:
            - address: 10.0.0.3/32
              comment: Mail Server 1
            - address: 10.0.0.4/32
              comment: Mail Server 2
        ALL_SERVERS:
          values:
            - WEB_SERVERS
            - MAIL_SERVERS
      services:
        HTTP:
          - protocol: tcp
            port: 80
        HTTPS:
          - protocol: tcp
            port: 443
        WEB:
          - HTTP
          - HTTPS
        HIGH_PORTS:
          - port: 1024-65535
            protocol: tcp
          - port: 1024-65535
            protocol: udp
    EOS

    (testpath/"policies/pol/example.pol.yaml").write <<~EOS
      filters:
      - header:
          comment: Example inbound
          targets:
            cisco: inbound extended
        terms:
          - name: accept-web-servers
            comment: Accept connections to our web servers.
            destination-address: WEB_SERVERS
            destination-port: WEB
            protocol: tcp
            action: accept
          - name: default-deny
            comment: Deny anything else.
            action: deny#{"  "}
    EOS

    assert_match "writing file: example.pol.acl", shell_output("#{bin}/aclgen 2>&1")
    assert_path_exists "example.pol.acl"
  end
end

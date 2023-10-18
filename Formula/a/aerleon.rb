class Aerleon < Formula
  include Language::Python::Virtualenv

  desc "Generate firewall configs for multiple firewall platforms"
  homepage "https://aerleon.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/b8/e5/f4386abc5d0e7f18bba22650514c1c14dbd235c93e11ac020f6c724614da/aerleon-1.7.0.tar.gz"
  sha256 "f3145c2a04f37c0463fbd80ee650f039bda9bc445e9c7fd4f18d8eeeda1b6ead"
  license "Apache-2.0"
  head "https://github.com/aerleon/aerleon.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ceba7fb078fc89a660a636c7189cc7a1e4e67ef06d376398dc975b8a070265d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "87b6867421332e7a522d4994eab1de30c2c54370326c436a1d660b14e1aa001d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7efe31db309d302da778df314d48e83a6754ef00fa42e6065997c4c7117b8339"
    sha256 cellar: :any_skip_relocation, sonoma:         "2c19d924d6ebde1a583316f495db2f91d1d840307e5f12481a67fd81c68ed6e6"
    sha256 cellar: :any_skip_relocation, ventura:        "c05ec64732361a650ed2cbec192c1d1eeddf02f6c8f00d9948444f4961246b1d"
    sha256 cellar: :any_skip_relocation, monterey:       "001c23a0759b113f67e16a9056de0fb61430fa788d33f9ced68973d4bfd5abd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "167fe5857147fb234003b7d04fafc857b9be6aedf1c5f0ae2fc50bdda89c2ad6"
  end

  depends_on "python-typing-extensions"
  depends_on "python@3.12"
  depends_on "pyyaml"

  resource "absl-py" do
    url "https://files.pythonhosted.org/packages/79/c9/45ecff8055b0ce2ad2bfbf1f438b5b8605873704d50610eda05771b865a0/absl-py-1.4.0.tar.gz"
    sha256 "d2c244d01048ba476e7c080bd2c6df5e141d211de80223460d5b3b8a2a58433d"
  end

  resource "ply" do
    url "https://files.pythonhosted.org/packages/e5/69/882ee5c9d017149285cab114ebeab373308ef0f874fcdac9beb90e0ac4da/ply-3.11.tar.gz"
    sha256 "00c7c1aaa88358b9c765b6d3000c6eec0ba42abca5351b095321aef446081da3"
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

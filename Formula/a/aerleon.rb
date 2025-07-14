class Aerleon < Formula
  include Language::Python::Virtualenv

  desc "Generate firewall configs for multiple firewall platforms"
  homepage "https://aerleon.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/ff/b1/5d996fe14f8f36597c1bec2d400166f63d5bf09e4af7876f9707c0f7830c/aerleon-1.10.0.tar.gz"
  sha256 "e36f2969bdf6c3d2785f68044cdb4007ff171241b7a2dbef0b07b9be212cdcd1"
  license "Apache-2.0"
  head "https://github.com/aerleon/aerleon.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9a0ce912cd094bb361a61ad6e74ed7c19588c07a2bbf30e976bc1924dc013a41"
    sha256 cellar: :any,                 arm64_sonoma:  "40c9f1fa8de67228d7e21c15377c4f6bf6d2718fb91baf9132e171090c1b9502"
    sha256 cellar: :any,                 arm64_ventura: "aba5f9c3d128f254ffcda39e935c7f28a0c36ae64b5d54ffd73cc1783e4a5cc5"
    sha256 cellar: :any,                 sonoma:        "09f5bf01a88afa1ef1592079f6f93e80035233d5bfb0677c6f7e20d6171bac68"
    sha256 cellar: :any,                 ventura:       "b7a17da4ed5ae27d30d3d3a9107e3f343a9e740ec3f807d22fedeb7d90d548d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9406804bd917c6d2af99909f2eab61bfc38e101fe32f4334c8fb447c972f580"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4107ba183dc15fc6c92b31f22de1542d6564f6196a7be214fa13ff2b9b99ba5d"
  end

  depends_on "libyaml"
  depends_on "python@3.13"

  conflicts_with "cgrep", because: "both install `cgrep` binaries"

  resource "absl-py" do
    url "https://files.pythonhosted.org/packages/79/c9/45ecff8055b0ce2ad2bfbf1f438b5b8605873704d50610eda05771b865a0/absl-py-1.4.0.tar.gz"
    sha256 "d2c244d01048ba476e7c080bd2c6df5e141d211de80223460d5b3b8a2a58433d"
  end

  resource "ply" do
    url "https://files.pythonhosted.org/packages/e5/69/882ee5c9d017149285cab114ebeab373308ef0f874fcdac9beb90e0ac4da/ply-3.11.tar.gz"
    sha256 "00c7c1aaa88358b9c765b6d3000c6eec0ba42abca5351b095321aef446081da3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/d1/bc/51647cd02527e87d05cb083ccc402f93e441606ff1f01739a62c8ad09ba5/typing_extensions-4.14.0.tar.gz"
    sha256 "8676b788e32f02ab42d9e7c61324048ae4c6d844a399eebace3d4979d75ceef4"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"def/definitions.yaml").write <<~YAML
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
    YAML

    (testpath/"policies/pol/example.pol.yaml").write <<~YAML
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
    YAML

    assert_match "writing file: example.pol.acl", shell_output("#{bin}/aclgen 2>&1")
    assert_path_exists "example.pol.acl"
  end
end

class ContainerStructureTest < Formula
  desc "Validate the structure of your container images"
  homepage "https://github.com/GoogleContainerTools/container-structure-test"
  url "https://github.com/GoogleContainerTools/container-structure-test/archive/v1.14.0.tar.gz"
  sha256 "a52a28f94f608ce2132b5b9ebfa29db0c3eb382f0d0644be3877e64713ae2900"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/container-structure-test.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "09425ba24a07cc526904d8a9a71a0591809ed0d2120eb8c836b18a0a277f2f28"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac67b4fa0a58c25ee63f9b664ccee63a8c410ad6d095bb13ea5fe1200a8f2877"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5f02284416cfd39331c161d5b0fc409c42229956cd588a081e5b178bc89685ae"
    sha256 cellar: :any_skip_relocation, monterey:       "924b7cf12f63b5ee248046c9f68f2d9de2c91838acf32da68b29bd7864c09afc"
    sha256 cellar: :any_skip_relocation, big_sur:        "4007f283f958fb44985d867500617ec0fecfcb0e70c8943d0e1c79ce235bd2a7"
    sha256 cellar: :any_skip_relocation, catalina:       "77e2b6d61f00faf44a948d6416591c1b643906208ce11be87c226c1dd93e320f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "183f1757591e1d72d3e2672277146f205168a8200eddd45920db6433d321edcf"
  end

  depends_on "go" => :build

  # Small Docker image to run tests against
  resource "test_resource" do
    url "https://gist.github.com/AndiDog/1fab301b2dbc812b1544cd45db939e94/raw/5160ab30de17833fdfe183fc38e4e5f69f7bbae0/busybox-1.31.1.tar", using: :nounzip
    sha256 "ab5088c314316f39ff1d1a452b486141db40813351731ec8d5300db3eb35a316"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/container-structure-test"
  end

  test do
    (testpath/"test.yml").write <<~EOF
      schemaVersion: "2.0.0"

      fileContentTests:
        - name: root user
          path: "/etc/passwd"
          expectedContents:
            - "root:x:0:0:root:/root:/bin/sh\\n.*"

      fileExistenceTests:
        - name: Basic executable
          path: /bin/test
          shouldExist: yes
          permissions: '-rwxr-xr-x'
    EOF

    args = %w[
      --driver tar
      --json
      --image busybox-1.31.1.tar
      --config test.yml
    ].join(" ")

    resource("test_resource").stage testpath
    json_text = shell_output("#{bin}/container-structure-test test #{args}")
    res = JSON.parse(json_text)
    assert_equal res["Pass"], 2
    assert_equal res["Fail"], 0
  end
end

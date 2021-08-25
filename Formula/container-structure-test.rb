class ContainerStructureTest < Formula
  desc "Validate the structure of your container images"
  homepage "https://github.com/GoogleContainerTools/container-structure-test"
  url "https://github.com/GoogleContainerTools/container-structure-test/archive/v1.10.0.tar.gz"
  sha256 "52ba2ff4e948c6740da6da8804aeb674cf631e4d470ae5d78af07f17ba0ecbec"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/container-structure-test.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "91fcb7cb88abaa849aa25cbf4a6f1d4d7115fd214f80f16e4a0cdb8e38c04e23"
    sha256 cellar: :any_skip_relocation, big_sur:       "fe1c78a41314a909b9251ac55e09a109dcfff01315bde3d515dd2344038183df"
    sha256 cellar: :any_skip_relocation, catalina:      "62fe8a2e6ee7931c9755dcede739cc54f27173362e1767c675f2fa244dbebf42"
    sha256 cellar: :any_skip_relocation, mojave:        "11d19adb68076f69c4fc9a27bdfd858cdb9260406e5ec72b15f04b08d795650c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4fc26d1a6f06f9f657f49b72d2ae8554af944ef36d7cbc45064638b24905e548"
  end

  depends_on "go" => :build

  # Small Docker image to run tests against
  resource "busybox-image-tar" do
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

    resource("busybox-image-tar").stage testpath
    json_text = shell_output("#{bin}/container-structure-test test #{args}")
    res = JSON.parse(json_text)
    assert_equal res["Pass"], 2
    assert_equal res["Fail"], 0
  end
end

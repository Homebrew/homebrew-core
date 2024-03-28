class ContainerStructureTest < Formula
  desc "Validate the structure of your container images"
  homepage "https://github.com/GoogleContainerTools/container-structure-test"
  url "https://github.com/GoogleContainerTools/container-structure-test/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "35be5d373260b72ac6c848b3ea418bc3b51a54104026880295147f150f27cae3"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/container-structure-test.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "856ff7c3f6ddf762d15ea2b69f5065d49f92143f7f4353d0999a2740e6c10cd7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4b50992a2021a742afebcd651562cc94580c8ab0dd6c040721496af67597516a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f878d441df542160bfb6b1d4b2281981518174dd33722771977befe95d60f9d3"
    sha256 cellar: :any_skip_relocation, sonoma:         "6eab5580e70fcf4c6fc57762ba17ba30c7ddd131fcbb62266683caa6d53d5463"
    sha256 cellar: :any_skip_relocation, ventura:        "f4c1d201809e0b798f40191a9c2700d256ac26b2ef9fffd00d1429e8ceef1300"
    sha256 cellar: :any_skip_relocation, monterey:       "d4a1ae1012216ae5593da0a694bd1768ad25ac18894b2f21315670b44eb857af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1f8f29a5b8091c70525e06261fdf5815ba96d787cba64f56fc5533b15980ece"
  end

  depends_on "go" => :build

  def install
    project = "github.com/GoogleContainerTools/container-structure-test"
    ldflags = %W[
      -s -w
      -X #{project}/pkg/version.version=#{version}
      -X #{project}/pkg/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/container-structure-test"
  end

  test do
    # Small Docker image to run tests against
    resource "homebrew-test_resource" do
      url "https://gist.github.com/AndiDog/1fab301b2dbc812b1544cd45db939e94/raw/5160ab30de17833fdfe183fc38e4e5f69f7bbae0/busybox-1.31.1.tar", using: :nounzip
      sha256 "ab5088c314316f39ff1d1a452b486141db40813351731ec8d5300db3eb35a316"
    end

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

    resource("homebrew-test_resource").stage testpath
    json_text = shell_output("#{bin}/container-structure-test test #{args}")
    res = JSON.parse(json_text)
    assert_equal res["Pass"], 2
    assert_equal res["Fail"], 0
  end
end

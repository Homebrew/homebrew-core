class ContainerStructureTest < Formula
  desc "Validate the structure of your container images"
  homepage "https://github.com/GoogleContainerTools/container-structure-test"
  url "https://github.com/GoogleContainerTools/container-structure-test/archive/refs/tags/v1.22.1.tar.gz"
  sha256 "186bb1493ebb3c597e53b2a7abd5460c683c63d404e44a64223d26bb3315841d"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/container-structure-test.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ffadb4b8e066a730a44df161a8994706c19299d4b2016e1f6446c4b87f4300d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ffadb4b8e066a730a44df161a8994706c19299d4b2016e1f6446c4b87f4300d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ffadb4b8e066a730a44df161a8994706c19299d4b2016e1f6446c4b87f4300d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e1bbe8f1cf6043c62b4108fca2107d9e967138b2bc064bb39a23a4f4762f607"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dcac556f58434bb4a0886090be35ee58c844b20507704c679a30043680c36cce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a5370012785c55e9fec1d69ccc950b88e84a36d4f6de86f322ba9a3919c3099"
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

    (testpath/"test.yml").write <<~YAML
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
    YAML

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

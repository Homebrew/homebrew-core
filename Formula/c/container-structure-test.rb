class ContainerStructureTest < Formula
  desc "Validate the structure of your container images"
  homepage "https://github.com/GoogleContainerTools/container-structure-test"
  url "https://github.com/GoogleContainerTools/container-structure-test/archive/refs/tags/v1.20.0.tar.gz"
  sha256 "7c5a492941c51e074edf6ea8af8ab7e77f695a89a27c7617c4ddbb3641a650ab"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/container-structure-test.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1f605ec58dc341353735af49d2952ea4e94c7a98c541474be20b49310c6d8d6c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f605ec58dc341353735af49d2952ea4e94c7a98c541474be20b49310c6d8d6c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f605ec58dc341353735af49d2952ea4e94c7a98c541474be20b49310c6d8d6c"
    sha256 cellar: :any_skip_relocation, sonoma:        "78a9a6d9bfb9e15551fa449dee354be4fd01c9b89c806a81387536c621e84ce7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cdd64ae6a720ab37daeb66364674c6f5e7606499d71c85db41edff665cfca498"
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

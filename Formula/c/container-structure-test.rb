class ContainerStructureTest < Formula
  desc "Validate the structure of your container images"
  homepage "https://github.com/GoogleContainerTools/container-structure-test"
  url "https://github.com/GoogleContainerTools/container-structure-test/archive/refs/tags/v1.22.0.tar.gz"
  sha256 "94f6ae60ddb13ba1774a226e3f2650f736871bad61a18982e0b825bde2ad568a"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/container-structure-test.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "985a9d8cdb2a082e042602c9e185ee354abfcfdbe51824dad8752679f66aa244"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "985a9d8cdb2a082e042602c9e185ee354abfcfdbe51824dad8752679f66aa244"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "985a9d8cdb2a082e042602c9e185ee354abfcfdbe51824dad8752679f66aa244"
    sha256 cellar: :any_skip_relocation, sonoma:        "b6c0bcd37369f2f03e8eaa6d0962f5e1a4e058f16a0430f304907d03fefd0886"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d3a65c251fb9281c834acf28d00ea86ff2e43ffd47fd9830f98a06762d1dd874"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1438c34759acb2d059ac82ca330d233f1ed50e2d2a1aa47b8e7a5b8e8879b7a8"
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

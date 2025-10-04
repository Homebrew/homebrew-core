class ContainerStructureTest < Formula
  desc "Validate the structure of your container images"
  homepage "https://github.com/GoogleContainerTools/container-structure-test"
  url "https://github.com/GoogleContainerTools/container-structure-test/archive/refs/tags/v1.21.1.tar.gz"
  sha256 "e29075885dac64ae88ef44d6d37b6f8f7e1cf6aa6cb298f641ce96fc279270bc"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/container-structure-test.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "26c63631775802c40ec12552e68fb579894b0bbd9ff5064924d479650f613c06"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26c63631775802c40ec12552e68fb579894b0bbd9ff5064924d479650f613c06"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26c63631775802c40ec12552e68fb579894b0bbd9ff5064924d479650f613c06"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b1ca5ac1b3121bdc1e9e8f1863f73e4096d43f120f2dcdac202c241d1a03520"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c3b923e12b6368b5a1991186d56cbae3db6a19f2fa1134bdd4a23b6d548560c"
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

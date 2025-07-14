class ContainerStructureTest < Formula
  desc "Validate the structure of your container images"
  homepage "https://github.com/GoogleContainerTools/container-structure-test"
  url "https://github.com/GoogleContainerTools/container-structure-test/archive/refs/tags/v1.19.3.tar.gz"
  sha256 "c91a76f7b4949775941f8308ee7676285555ae4756ec1ec990c609c975a55f93"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/container-structure-test.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48ab6f7e67e0ccb7f9b1ad136fdd0a20d2d211991eddd6e2a172380790d7d699"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48ab6f7e67e0ccb7f9b1ad136fdd0a20d2d211991eddd6e2a172380790d7d699"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "48ab6f7e67e0ccb7f9b1ad136fdd0a20d2d211991eddd6e2a172380790d7d699"
    sha256 cellar: :any_skip_relocation, sonoma:        "16ed431b05fd07b2f803a517bb8665eddf9c047a3ecac0888c1343e1dc277add"
    sha256 cellar: :any_skip_relocation, ventura:       "16ed431b05fd07b2f803a517bb8665eddf9c047a3ecac0888c1343e1dc277add"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5d7d0f9047eb0a3e0bc8b94d46e32581096d1fd3018591025d07d71bd186958"
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

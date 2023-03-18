class ContainerStructureTest < Formula
  desc "Validate the structure of your container images"
  homepage "https://github.com/GoogleContainerTools/container-structure-test"
  url "https://github.com/GoogleContainerTools/container-structure-test/archive/v1.15.0.tar.gz"
  sha256 "b5dd39d572b80617f0bc72959bcbe7ec649dd2e141ea9a119c04a84b4783e3c7"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/container-structure-test.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b87be66edb28fda43f827215ce199da93090824268508cb3b590ea7f3e2ff8ac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b87be66edb28fda43f827215ce199da93090824268508cb3b590ea7f3e2ff8ac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b87be66edb28fda43f827215ce199da93090824268508cb3b590ea7f3e2ff8ac"
    sha256 cellar: :any_skip_relocation, ventura:        "b2951509364276019ec26fd856d97d435a765b0ab85c12c92eabe744f7217e79"
    sha256 cellar: :any_skip_relocation, monterey:       "b2951509364276019ec26fd856d97d435a765b0ab85c12c92eabe744f7217e79"
    sha256 cellar: :any_skip_relocation, big_sur:        "b2951509364276019ec26fd856d97d435a765b0ab85c12c92eabe744f7217e79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "114025ab8bd18b05a9fa5a0b145cc09f136b0d3f4bf77ded5c92b18e85b1a8d8"
  end

  depends_on "go" => :build

  # Small Docker image to run tests against
  resource "test_resource" do
    url "https://gist.github.com/AndiDog/1fab301b2dbc812b1544cd45db939e94/raw/5160ab30de17833fdfe183fc38e4e5f69f7bbae0/busybox-1.31.1.tar", using: :nounzip
    sha256 "ab5088c314316f39ff1d1a452b486141db40813351731ec8d5300db3eb35a316"
  end

  def install
    project = "github.com/GoogleContainerTools/container-structure-test"
    ldflags = %W[
      -s -w
      -X #{project}/pkg/version.version=#{version}
      -X #{project}/pkg/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/container-structure-test"
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

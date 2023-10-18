class ContainerStructureTest < Formula
  desc "Validate the structure of your container images"
  homepage "https://github.com/GoogleContainerTools/container-structure-test"
  url "https://github.com/GoogleContainerTools/container-structure-test/archive/v1.16.0.tar.gz"
  sha256 "4fe56bd96340873ac4aa677a770cec1b7aebdd841c11e368d90f2a9d369cf133"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/container-structure-test.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4f0a42506e3e746d825c9e97cef6e6ed28b4f533a9b4b7cd4a158918d0e516a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "15e62a3393f77ea1f6c548cba9cc4fe5f373bf34843f89e408589ed3f282aaa1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "15e62a3393f77ea1f6c548cba9cc4fe5f373bf34843f89e408589ed3f282aaa1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "15e62a3393f77ea1f6c548cba9cc4fe5f373bf34843f89e408589ed3f282aaa1"
    sha256 cellar: :any_skip_relocation, sonoma:         "a22afd469c8e8972190c5f7ff8fa98416aa32820e369b5b71f32f1e8c27201ce"
    sha256 cellar: :any_skip_relocation, ventura:        "a8bcd1c016586b271614ee870fce7e65bfffd19061ef7e47400da3bc1a7c7f1f"
    sha256 cellar: :any_skip_relocation, monterey:       "a8bcd1c016586b271614ee870fce7e65bfffd19061ef7e47400da3bc1a7c7f1f"
    sha256 cellar: :any_skip_relocation, big_sur:        "a8bcd1c016586b271614ee870fce7e65bfffd19061ef7e47400da3bc1a7c7f1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fcc11916f345b4df1f8369a2fd7c00a04464ed58037187bd66852d4556c77264"
  end

  depends_on "go" => :build

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

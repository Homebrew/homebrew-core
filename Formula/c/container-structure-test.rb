class ContainerStructureTest < Formula
  desc "Validate the structure of your container images"
  homepage "https://github.com/GoogleContainerTools/container-structure-test"
  url "https://github.com/GoogleContainerTools/container-structure-test/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "35be5d373260b72ac6c848b3ea418bc3b51a54104026880295147f150f27cae3"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/container-structure-test.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f038adce4df86137afbd1bdbd1f9585eb7fa218db412ca6693b4342f746387b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2a79c88d9269069353c7af8e28b53722cb66eb26818f4479112a905f24f17f39"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d3f86a5340feae9a44bcb0102b262bc31c83fd61d439a5a1430314f4f08cd4d"
    sha256 cellar: :any_skip_relocation, sonoma:         "ec77c7ab594a7bfbf27a687094cf159c36fd196c507551a122bfa85d30db4f96"
    sha256 cellar: :any_skip_relocation, ventura:        "512b962c9a6ab3c5d9accd00f6ce4dd3b595779f77aa521beb1b194246485abc"
    sha256 cellar: :any_skip_relocation, monterey:       "f299f6e84c802461b0e1eb98ec500fa86e6d0bf017be86cb1d26ad2ffde6c3a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3078aa1886902cdd8656382b7fed27b151e9257d0a0d5eaf61bd1a68bd9d5ec1"
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

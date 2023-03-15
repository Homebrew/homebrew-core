class ContainerStructureTest < Formula
  desc "Validate the structure of your container images"
  homepage "https://github.com/GoogleContainerTools/container-structure-test"
  url "https://github.com/GoogleContainerTools/container-structure-test/archive/v1.15.0.tar.gz"
  sha256 "b5dd39d572b80617f0bc72959bcbe7ec649dd2e141ea9a119c04a84b4783e3c7"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/container-structure-test.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc5f1f0df698f0d802139acc41623b97bdf2ad08d35a7e4659aad5ca1574d72e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e344c0b7bed8f52093b54acc53859195b9db9fbd5a77c7315ffa480ae64ff43"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "53848d24575c7b9906c7b7648777a41c1e0a720e7ecd14a757c651a5fad9a2cc"
    sha256 cellar: :any_skip_relocation, ventura:        "901c27176141d49fb77edbd0744c0bee2a030027fc39e3eae984ebee489dab49"
    sha256 cellar: :any_skip_relocation, monterey:       "00ed46e545005d6ec023960645492ba26554ca94ce3204e975e725f1045feccb"
    sha256 cellar: :any_skip_relocation, big_sur:        "d094b14c62b3bf32de53de3e189be7d618c47a8de22ab881df1af8e78de92087"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "abb24fb7fc9e21d2406aa46f302f928663959c2446c5a199055fe8bab307d76c"
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

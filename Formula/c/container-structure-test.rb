class ContainerStructureTest < Formula
  desc "Validate the structure of your container images"
  homepage "https://github.com/GoogleContainerTools/container-structure-test"
  url "https://github.com/GoogleContainerTools/container-structure-test/archive/refs/tags/v1.18.1.tar.gz"
  sha256 "56fa7c8f2a080a0970b06c3fabc29367cb45ef6950526c24a41b07e813f77dfa"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/container-structure-test.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "856a30d397fe57e05dbe95b92fe2005708448093cc85eb9a20830686d5f0fac7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "12079d86dab2c1bfb4bfbea61115cb12d4d8f2723d9e5509f8d90ac77ae0c2a6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5244a8f134cd010c2b135c4506998f7c60c2b6c8db06980ae9ae6cffa18c974"
    sha256 cellar: :any_skip_relocation, sonoma:         "292ea9df3cc53fe74fe1b6dcf6947d6f2012ad6028392b399ea9510e3555ebcd"
    sha256 cellar: :any_skip_relocation, ventura:        "d56f868ebe3edec78945ac401c3179b2578b2c58714d26cb3c1ccf37295d2c1b"
    sha256 cellar: :any_skip_relocation, monterey:       "0ec3dbfe41975d74218fcc6ec0f831a4ab90945e087f97f0b80fa51dc223d33c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9faafd7fea3646d4ec4c20dce91b1a123374982d4e4a09617a6f0817e26bf2f5"
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

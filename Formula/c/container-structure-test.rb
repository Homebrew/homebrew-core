class ContainerStructureTest < Formula
  desc "Validate the structure of your container images"
  homepage "https://github.com/GoogleContainerTools/container-structure-test"
  url "https://github.com/GoogleContainerTools/container-structure-test/archive/refs/tags/v1.19.1.tar.gz"
  sha256 "b56a53fb7734f93216b60f8cdd3b98fbbd767e9f412c061d4fa4798e579c4971"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/container-structure-test.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "49c349ddf1486755e25d7ab7528c0f0b2073a0c226dd74349ba512ce75e9b7f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b5b16ad54b7ecddf8af7c53b55cf96ff1f015ed7766f2c2029d91fb999c10b75"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "724947ff2d136017419342489b46518fd1cda905bb244c56f26cbd2e63f5d42c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "18ae4d7d3d74533e2e2e2173eec4df779710eaf9b1bf6ac964a24004313873b2"
    sha256 cellar: :any_skip_relocation, sonoma:         "57c09a7d40144ee1d734270f610330a9b255991b79e18f1ee1f7064305acd1b4"
    sha256 cellar: :any_skip_relocation, ventura:        "abc03ff1cd41400d83e24cb564f75eb7924644673be453067933cbaa6b5b642a"
    sha256 cellar: :any_skip_relocation, monterey:       "2c7bd833f7eb40d84758f596c29dca3377ac4f10851839db921b7deb934231bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df6f87970813e9d98d617a37e22e8638aa5bd808cee04cbfa9bb2d0b5cd4805a"
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

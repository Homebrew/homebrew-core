class ContainerStructureTest < Formula
  desc "Validate the structure of your container images"
  homepage "https://github.com/GoogleContainerTools/container-structure-test"
  url "https://github.com/GoogleContainerTools/container-structure-test/archive/v1.11.0.tar.gz"
  sha256 "38bf793106da6cf7bfead49fae2a75c51609a304de4580af099eb57c5a018761"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/container-structure-test.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6415959aaadf01b87f3d318f03f308aa6d469a006dece2d5d687a37ea64d59e8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c64487a9ad907aded29beec96a2d51eb793c796db50322ef676ef30cf08a0586"
    sha256 cellar: :any_skip_relocation, monterey:       "4c4aeabd45db69abb15f9961ea0d3c3f8dbeaf7a9d0647de34d6b377b5f2fa4c"
    sha256 cellar: :any_skip_relocation, big_sur:        "0f711053af10c08ebcb76ce929d8ba1226255337b6c180c0ded43c49a62f111d"
    sha256 cellar: :any_skip_relocation, catalina:       "972b5d5682bb468c2607530b3bb259d9a3cc8ba6b59f33f023c1d55bf0747426"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc950bdfb9a5e20081952efa0f48e589413e2739576d9711d8581002ffbb5d64"
  end

  depends_on "go" => :build

  # Small Docker image to run tests against
  resource "test_resource" do
    url "https://gist.github.com/AndiDog/1fab301b2dbc812b1544cd45db939e94/raw/5160ab30de17833fdfe183fc38e4e5f69f7bbae0/busybox-1.31.1.tar", using: :nounzip
    sha256 "ab5088c314316f39ff1d1a452b486141db40813351731ec8d5300db3eb35a316"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/container-structure-test"
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

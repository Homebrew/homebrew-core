class ContainerStructureTest < Formula
  desc "Validate the structure of your container images"
  homepage "https://github.com/GoogleContainerTools/container-structure-test"
  url "https://github.com/GoogleContainerTools/container-structure-test/archive/v1.10.0.tar.gz"
  sha256 "52ba2ff4e948c6740da6da8804aeb674cf631e4d470ae5d78af07f17ba0ecbec"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/container-structure-test.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "24442f575335f02d97b542f410e76bd944319001b72f06be9f366bd7e5beef89" => :big_sur
    sha256 "37a50666b3c5a086903132ca98866fbcdcc3171fc1f83ccb2780d67b608d1f57" => :arm64_big_sur
    sha256 "e9901c9334658108c1aed10c2d0e8ae6509a436f69133b14fe8452978e7cf9fa" => :catalina
    sha256 "8b8173563086f3e7587b7b7c8419bbca9196f52460a80636070225636075611b" => :mojave
    sha256 "523c4f21e5ce23befd82ae9d5395785c7541736b3b43e827a04ecae61e588791" => :high_sierra
  end

  depends_on "go" => :build

  # Small Docker image to run tests against
  resource "busybox-image-tar" do
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

    resource("busybox-image-tar").stage testpath
    json_text = shell_output("#{bin}/container-structure-test test #{args}")
    res = JSON.parse(json_text)
    assert_equal res["Pass"], 2
    assert_equal res["Fail"], 0
  end
end

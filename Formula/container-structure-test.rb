class ContainerStructureTest < Formula
  desc "Validate the structure of your container images"
  homepage "https://github.com/GoogleContainerTools/container-structure-test"
  url "https://github.com/GoogleContainerTools/container-structure-test.git",
      :tag      => "v1.8.0",
      :revision => "19abf36d1451cb27f8e0f5ec8260815c73184bd4"
  head "https://github.com/GoogleContainerTools/container-structure-test.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c9b6726618230718c7d0b72ae27b888a5c9581f15835434df67732bcf1f8cf5d" => :catalina
    sha256 "db5abb38170c2fb7cb003463900d080dfde77e469d6134f7d1b4dcd98c38db2c" => :mojave
    sha256 "9e5641996fac66e5e9eb85816db964655777f82cff47d332bbaebf5e13c4d62b" => :high_sierra
  end

  depends_on "go" => :build

  # Small Docker image to run tests against
  resource "busybox-image-tar" do
    url "https://gist.github.com/AndiDog/1fab301b2dbc812b1544cd45db939e94/raw/5160ab30de17833fdfe183fc38e4e5f69f7bbae0/busybox-1.31.1.tar",
      :using => :nounzip
    sha256 "ab5088c314316f39ff1d1a452b486141db40813351731ec8d5300db3eb35a316"
  end

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/GoogleContainerTools/container-structure-test"
    dir.install buildpath.children - [buildpath/".brew_home"]
    cd dir do
      system "make"
      bin.install "out/container-structure-test"
      prefix.install_metafiles
    end
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

    resource("busybox-image-tar").stage testpath
    json_text = shell_output("#{bin}/container-structure-test test --driver tar --json --image busybox-1.31.1.tar --config test.yml")
    res = JSON.parse(json_text)
    assert_equal res["Pass"], 2
    assert_equal res["Fail"], 0
  end
end

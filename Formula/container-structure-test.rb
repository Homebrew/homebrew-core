class ContainerStructureTest < Formula
  desc "Validate the structure of your container images"
  homepage "https://github.com/GoogleContainerTools/container-structure-test"
  url "https://github.com/GoogleContainerTools/container-structure-test/archive/v1.9.0.tar.gz"
  sha256 "6a70b123a5a7781501109912249bc1209527d5dbee026e38777a25340b77a1df"
  head "https://github.com/GoogleContainerTools/container-structure-test.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "51c418c5331fa47eb2a4fcaad891a9fdf16b1f1603350845cbbcef5e9b555306" => :catalina
    sha256 "284e7ef67863ec90229ccae95dc240c850803aff531476f26194a84ed8cf33c7" => :mojave
    sha256 "5c176caeb206957f6a943faad2a194ee88ebd5d3e6ed02cd6d9441fd3d1556c9" => :high_sierra
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

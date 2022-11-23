class ContainerStructureTest < Formula
  desc "Validate the structure of your container images"
  homepage "https://github.com/GoogleContainerTools/container-structure-test"
  url "https://github.com/GoogleContainerTools/container-structure-test/archive/v1.14.0.tar.gz"
  sha256 "a52a28f94f608ce2132b5b9ebfa29db0c3eb382f0d0644be3877e64713ae2900"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/container-structure-test.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a3d97cb1dba9becb523b3100ff97b04e628b7d1ea557b388767eca1be95b814a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "451c342615127505d2a786d36a4e8ef7dd1935dd8bfc69b46c8556f975bf05bb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "82ab50abc3dcfab4abd223dac5fefc1147af4814b2e2b53be8784eae3f70c957"
    sha256 cellar: :any_skip_relocation, monterey:       "ce3d85375f4a296e5496c0ac0672fdeca4ac4d867e7b7df7678b4affcd6a6603"
    sha256 cellar: :any_skip_relocation, big_sur:        "0f35dc686ae3a6f7df920cb423a9af2d78c79b0d5b20cb3749420feb9ac06532"
    sha256 cellar: :any_skip_relocation, catalina:       "0ba2f6cd7b5e11172e92d189f000051336b74d8603efb088cf984b6857ef54f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd848aaa6f423a554cc96430d63a69c2d7d0d4159da5ad74f4d6e545de748045"
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

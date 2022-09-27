class Oras < Formula
  desc "OCI Registry As Storage"
  homepage "https://github.com/oras-project/oras"
  url "https://github.com/oras-project/oras/archive/v0.15.0.tar.gz"
  sha256 "0d75af9e7d95b8c6b61328cd7587e1a49c64f1a6f2f5af34f40a0e576562857f"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2a7b233c3a29b6a396f2efe1a5f74d63825f52e5d6fd60927a9965bca682c3d2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3c8c747631a3ecb103ac4a464b2ea08414a766fe245b4fe7207e4aca1fe3afa5"
    sha256 cellar: :any_skip_relocation, monterey:       "02bda84966ef1bf5e9ca10c2a603b167367d2641ff9ff862c9be2187cd02232a"
    sha256 cellar: :any_skip_relocation, big_sur:        "12551fa46c04d1add6671d15a299a0aceb6a4f4fe94a40c167c7ad5d53614024"
    sha256 cellar: :any_skip_relocation, catalina:       "784f79b53a54993958df9a24d4efab705cccaa3c60e774daeb658d0fb217d894"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b740f00aa9aeb063f8e6fada3313902b667a7d7c50b714d228ad356ddbba1e71"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X oras.land/oras/internal/version.Version=#{version}
      -X oras.land/oras/internal/version.BuildMetadata=Homebrew
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/oras"
  end

  test do
    assert_match "#{version}+Homebrew", shell_output("#{bin}/oras version")

    port = free_port
    contents = <<~EOS
      {
        "key": "value",
        "this is": "a test"
      }
    EOS
    (testpath/"test.json").write(contents)

    # Although it might not make much sense passing the JSON as both manifest and payload,
    # it helps make the test consistent as the error can randomly switch between either hash
    output = shell_output("oras push localhost:#{port}/test-artifact:v1 " \
                          "--config test.json:application/vnd.homebrew.test.config.v1+json " \
                          "./test.json 2>&1", 1)
    assert_match "#{port}: connect: connection refused", output
  end
end

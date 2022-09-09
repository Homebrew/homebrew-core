class Oras < Formula
  desc "OCI Registry As Storage"
  homepage "https://github.com/oras-project/oras"
  url "https://github.com/oras-project/oras/archive/v0.16.0.tar.gz"
  sha256 "37bac099dd72de50cf2405dd092908b1039db142faf81ab1c9d22ced2e0d1ea6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "58fca31793789b47ed7d8072056eaceee74a7da3f05793353ff33b329499ba84"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b90ec0087e27d88bd4a787185e6608bdd30c70ad4e5fe21cf94796292e1ce39b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fb7a177fec1d7ab992783de091527c1d611e3b01cc883f3009a53098da694702"
    sha256 cellar: :any_skip_relocation, ventura:        "efc057bc7f248ca6a7f48bb1833a5affdb317f54319da7467e9d5f713af62eba"
    sha256 cellar: :any_skip_relocation, monterey:       "edf4a4c5f44933565062b02cc57893a676c910450b57bea3d93dfc56ac389863"
    sha256 cellar: :any_skip_relocation, big_sur:        "21e8431478564cf9690ed154c02d44440eedbd077bb6df2eca09fa3ee0e8c82b"
    sha256 cellar: :any_skip_relocation, catalina:       "31ea37cd67526f34b2b96f842e79945d1cc8702fafda258e8d9a568afca76c21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b007b64644fc99d0c74c67f4f9a01a28cab497ad5fe87b56b90b2ccb98a7e5c0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X oras.land/oras/internal/version.Version=#{version}
      -X oras.land/oras/internal/version.BuildMetadata=Homebrew
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/oras"

    generate_completions_from_executable(bin/"oras", "completion")
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

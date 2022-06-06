class ArduinoCli < Formula
  desc "Arduino command-line interface"
  homepage "https://github.com/arduino/arduino-cli"
  url "https://github.com/arduino/arduino-cli.git",
      tag:      "0.23.0",
      revision: "899dc91b3e2e12948badaffc25eca2cfaefa2eda"
  license "GPL-3.0-only"
  head "https://github.com/arduino/arduino-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "14059e9426764c67f82e777b58ad474cb97edbc8cbb3bc47d85c3bf104689bd5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7dfab4653e679f08b935f243cab2941be847d07403dd90deb75055e2674416ae"
    sha256 cellar: :any_skip_relocation, monterey:       "2f4b83fbe895e74b4e39cb83009ce0de862b5386b37f35780a51040abcb1a5e6"
    sha256 cellar: :any_skip_relocation, big_sur:        "fb56c1951a0d092b7ad159e0d5c59261061a80a080e00aa9f8efb65e1ebb5919"
    sha256 cellar: :any_skip_relocation, catalina:       "a8e597af1b23aac4d071753482787ae725787dc703df35aa051bd8ebaee57533"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3c9149b0898e105763ae8375ac025c23944d6e6ea3617fc828cd5aaf58d81a6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/arduino/arduino-cli/version.versionString=#{version}
      -X github.com/arduino/arduino-cli/version.commit=#{Utils.git_head(length: 8)}
      -X github.com/arduino/arduino-cli/version.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    output = Utils.safe_popen_read(bin/"arduino-cli", "completion", "bash")
    (bash_completion/"arduino-cli").write output

    output = Utils.safe_popen_read(bin/"arduino-cli", "completion", "zsh")
    (zsh_completion/"_arduino-cli").write output

    output = Utils.safe_popen_read(bin/"arduino-cli", "completion", "fish")
    (fish_completion/"arduino-cli.fish").write output
  end

  test do
    system "#{bin}/arduino-cli", "sketch", "new", "test_sketch"
    assert File.directory?("#{testpath}/test_sketch")

    version_output = shell_output("#{bin}/arduino-cli version 2>&1")
    assert_match("arduino-cli  Version: #{version}", version_output)
    assert_match("Commit:", version_output)
    assert_match(/[a-f0-9]{8}/, version_output)
    assert_match("Date: ", version_output)
    assert_match(/\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z/, version_output)
  end
end

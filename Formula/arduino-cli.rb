class ArduinoCli < Formula
  desc "Arduino command-line interface"
  homepage "https://github.com/arduino/arduino-cli"
  url "https://github.com/arduino/arduino-cli.git",
      tag:      "0.20.1",
      revision: "abb2144951a86092335adcbc45378a9e33a0879e"
  license "GPL-3.0-only"
  head "https://github.com/arduino/arduino-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b6352459905f8d54431563996850cd644894c5388d71c44f13d1bf789ab14493"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0c1f140641c3cad9a68a484ef3822cf2a0dcfab52d8bb8568b105470fe4aa672"
    sha256 cellar: :any_skip_relocation, monterey:       "b20d1d0612b96baa9297a5ec3e0f125f9a1af67ce046f6be5c6b548c2159fb84"
    sha256 cellar: :any_skip_relocation, big_sur:        "d0ae155db75d22103048e660ca955343bec796368ef7cef04691e50b68c912f8"
    sha256 cellar: :any_skip_relocation, catalina:       "fdb8f090b9472fdc6520baff997c9c540b8a303788d0b72f35f078d6eaa4d891"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "977f9ebad93c919716ab3bea12a6892dda02b7efc6617e8bbceaf7edd8f59362"
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

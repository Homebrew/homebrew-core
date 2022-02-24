class ArduinoCli < Formula
  desc "Arduino command-line interface"
  homepage "https://github.com/arduino/arduino-cli"
  url "https://github.com/arduino/arduino-cli.git",
      tag:      "0.21.1",
      revision: "9fcbb392b08d2574e8182e920ac1a5779a1adf75"
  license "GPL-3.0-only"
  head "https://github.com/arduino/arduino-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "38dcdb2aa8992ea6043bf40fb161838cc7c31a2ae036fe990e3ae82ffcf9802a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "09a7ad1e233c8b590391739c0bd33d97758435e26c551f42ddbd774cf615e1ee"
    sha256 cellar: :any_skip_relocation, monterey:       "24454d21c22d956a7c077f5db189def6aa2f7a1b7a6df483b2cebf009a41496e"
    sha256 cellar: :any_skip_relocation, big_sur:        "56e3c12005b565fd87a59a583e5c55ac8844b44631f2d68eebdc857e96970392"
    sha256 cellar: :any_skip_relocation, catalina:       "d860fe43a1724de4fecaf4fd50cb87d6f644b3cfe9c5b0d5ead942d9104270e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b55a2bb39a936ee0847cbd6bf83e97c18c2deedcf21812d7cd0a2b592c2fb475"
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

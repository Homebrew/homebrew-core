class ArduinoCli < Formula
  desc "Arduino command-line interface"
  homepage "https://github.com/arduino/arduino-cli"
  url "https://github.com/arduino/arduino-cli.git",
      tag:      "0.34.2",
      revision: "963c1a76c9d2a6ea37956a100c0cd8070260208f"
  license "GPL-3.0-only"
  head "https://github.com/arduino/arduino-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e5bb782ba1730a94a1955918ffd1eccb73b0fb8289eb4c1738f78b8d2b81675f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f5f0cdbc4aa0e12d662c58bf86d19a629e602d7e515da9e8f55d2c7907d0b75"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9aa795f129f9e16c34826f1ea10d279987a9ced905c459f2fc5e4b6711863d46"
    sha256 cellar: :any_skip_relocation, ventura:        "858edd6bb2966bf4be02d60100f8410f6b389713aafca7a9252417d2e3f2bc35"
    sha256 cellar: :any_skip_relocation, monterey:       "3a25b9470fe4225400272cb31cdc036ce9c051200b806d84254a4bfb466f0553"
    sha256 cellar: :any_skip_relocation, big_sur:        "9b4f95824251cc8e3c1425ddc4f611823ac92be906d57f309a06ba13d54127e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16212597a16450c46cd31d56092b152185b9f903f8d2e28ecb9525b47c157669"
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

    generate_completions_from_executable(bin/"arduino-cli", "completion")
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

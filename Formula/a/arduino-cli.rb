class ArduinoCli < Formula
  desc "Arduino command-line interface"
  homepage "https://github.com/arduino/arduino-cli"
  url "https://github.com/arduino/arduino-cli.git",
      tag:      "0.34.1",
      revision: "048415c5e6334f8435ffc4216df0b03e306c3e35"
  license "GPL-3.0-only"
  head "https://github.com/arduino/arduino-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7dfbeed2a3232177811b9227af95143bcacfbb2ca45120bd177531ef1f3d324a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0596f9e82ec499faa15c5a84ad371ea9620a161151d6f2cff2e34a8e4ee841a3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9872688b3b4e97e7b650f1f4ff963c892f7712e4077716c4f52a23ab378396f3"
    sha256 cellar: :any_skip_relocation, ventura:        "935c294fc688c7bb30614c76a2405388bdd2de8fb523e7336ccd35c3fa424ac8"
    sha256 cellar: :any_skip_relocation, monterey:       "9162548a1251a39736344b43f229badd900169bb661c13758930360d8c4cd16b"
    sha256 cellar: :any_skip_relocation, big_sur:        "ad8f4afd65cf5a49786cab1663e329195c8b9cc23187bee0955e40e387013810"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55ee8d2f1615eeb7b17ddfd9dc0ba3c97fea4eeb3cc1553c3ccb3a8a1b63dd0f"
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

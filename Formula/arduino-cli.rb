class ArduinoCli < Formula
  desc "Arduino command-line interface"
  homepage "https://github.com/arduino/arduino-cli"
  url "https://github.com/arduino/arduino-cli.git",
     tag:      "0.11.0",
     revision: "0296f4df116385f868b67c5ffa7393936c3345c9"
  license "GPL-3.0"
  revision 2
  head "https://github.com/arduino/arduino-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7d6e6a081632c6cb89e60636c3a7e6989375d10f8ab0f350927f68ea8957ed42" => :catalina
    sha256 "878390cd1048b3370de84200bf37e718b37252ae9daa437cac543635ba3bf482" => :mojave
    sha256 "b84292063439746cbaf314a60172e94659f90a6b80eaaab8f138b2ec4c128c43" => :high_sierra
  end

  depends_on "go" => :build

  def install
    commit = Utils.safe_popen_read("git", "rev-parse", "HEAD").chomp
    ldflags = %W[
      -s -w
      -X github.com/arduino/arduino-cli/version.versionString=#{version}
      -X github.com/arduino/arduino-cli/version.commit=#{commit}
    ]
    system "go", "build", *std_go_args, "-ldflags", ldflags.join(" ")

    output = Utils.safe_popen_read({ "SHELL" => "bash" }, "#{bin}/arduino-cli", "completion", "bash")
    (bash_completion/"arduino-cli").write output

    output = Utils.safe_popen_read({ "SHELL" => "zsh" }, "#{bin}/arduino-cli", "completion", "zsh")
    (zsh_completion/"_arduino-cli").write output

    output = Utils.safe_popen_read({ "SHELL" => "fish" }, "#{bin}/arduino-cli", "completion", "fish")
    (fish_completion/"arduino-cli.fish").write output
  end

  test do
    system "#{bin}/arduino-cli", "sketch", "new", "test_sketch"
    assert File.directory?("#{testpath}/test_sketch")

    version_output = shell_output("#{bin}/arduino-cli version 2>&1")
    assert_match "arduino-cli Version: #{version}", version_output
  end
end

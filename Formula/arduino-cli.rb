class ArduinoCli < Formula
  desc "Arduino command-line interface"
  homepage "https://github.com/arduino/arduino-cli"
  url "https://github.com/arduino/arduino-cli.git",
     :tag      => "0.10.0",
     :revision => "ec5c3ed105b32c5654fd60131a667f8557b196d5"
  head "https://github.com/arduino/arduino-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7b1ca46a923b596e62511d1e600f3cd733008ab7f4f01d2edca16e6950ca3337" => :catalina
    sha256 "babb7bf072b439ec91e04856b36bbddd52f99829dab91e1f64dee75ccd8c9511" => :mojave
    sha256 "4b7c66cb750089aadf05d3f40801715edeff0a1ad5b9bb3e99b920c6fe033130" => :high_sierra
  end

  depends_on "go" => :build

  def install
    commit = Utils.popen_read("git", "rev-parse", "HEAD").chomp
    system "go", "build", "-ldflags",
           "-s -w -X github.com/arduino/arduino-cli/version.versionString=#{version} " \
           "-X github.com/arduino/arduino-cli/version.commit=#{commit}",
           "-o", bin/"arduino-cli"
  end

  test do
    system "#{bin}/arduino-cli", "sketch", "new", "test_sketch"
    assert File.directory?("#{testpath}/test_sketch")
  end
end

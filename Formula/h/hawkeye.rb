class Hawkeye < Formula
  desc "Simple license header checker and formatter, in multiple distribution forms"
  homepage "https://github.com/korandoru/hawkeye"
  url "https://github.com/korandoru/hawkeye/archive/refs/tags/v6.4.1.tar.gz"
  sha256 "80895435f3f24104005d9d4f1308d12dafad53daded32e245ea24d5bfb883de1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8b251e5c88de184dabaa393eaef0d643644ccefa5e107f6f2555e02c8b67ed2a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "703bd5845de5d986dfffbc93d302980e964099c3be90a476cf5a46202d187370"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "426b9968c38b0ed5cfdb5621aea07852b51caaa92fad6e07eb0c4533f15d1fc7"
    sha256 cellar: :any_skip_relocation, sonoma:        "becc8e91289c9583268aaab44b94b71fb71c6629dec69a30b77096ec371f2e60"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a073996d9932d24713a25113bcda6d374261972d3fcf3750e37daf484476204"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a34c5a9d259e653bdc9c6db4945831526b8aad5ea5b936e857255cf8fbf7c4e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_includes shell_output("#{bin}/hawkeye --version"), "hawkeye \nversion: #{version}\n"

    configfile = testpath/"licenserc.toml"
    configfile.write <<~EOS
      inlineHeader = """
      Copyright © 1970
      """

      includes = ["licenserc.toml"]
    EOS

    shell_output("#{bin}/hawkeye format", 1)
    assert File.read("licenserc.toml").start_with?("# Copyright © 1970")
  end
end

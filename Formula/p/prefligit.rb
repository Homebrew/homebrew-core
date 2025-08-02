class Prefligit < Formula
  desc "Pre-commit re-implemented in Rust"
  homepage "https://github.com/j178/prefligit"
  url "https://github.com/j178/prefligit/archive/refs/tags/v0.0.16.tar.gz"
  sha256 "d5533dce84a02e4f731c95215b003d7e11b87c2fa9c54ccf40df65c5bd983f37"
  license "MIT"
  head "https://github.com/j178/prefligit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e5a1c6910ed0ea1a0091264304dd77e28390f81ba665b08b8ed12ad39827b1e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f465c7475825c43563b8f0ea6f95b560d8cab11771e3c6672b67f52dc1cc01b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "83940f57902e2d3bbb23be11c51d03df17793d6eecf6c1d722b49f7490bcf7e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "e88785a430fed985381464e7101de70dc5fa3094e170024f6d855e8a68fa43c1"
    sha256 cellar: :any_skip_relocation, ventura:       "97d846bafa589f92c86acf1cd134f67a92ae532e01f8abf4c29641432cd9b673"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f1fd1e9bca0a71bf78f3e8726ad304db8e4cc5a33cf64cda7d85cb1de5fe23b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69a3cac803d4d1035c89f4ff02d8f46bf3fe114e2bebc750f5b1757a88a81db9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"prefligit", "generate-shell-completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/prefligit --version")

    output = shell_output("#{bin}/prefligit sample-config")
    assert_match "See https://pre-commit.com for more information", output
  end
end

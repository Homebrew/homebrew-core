class MistCli < Formula
  desc "Mac command-line tool that automatically downloads macOS Firmwares / Installers"
  homepage "https://github.com/ninxsoft/mist-cli"
  url "https://github.com/ninxsoft/mist-cli/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "aec30c9ff043e17ce0e6dd563480bd8015910ea1f110d4b767522e41e92bc00e"
  license "MIT"
  head "https://github.com/ninxsoft/mist-cli.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bba361d2ed55852c3cfbe42a3a3588d98b0d4376d82002f9809e3145e9da43f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "efc0268da168bdef3957814c3abab5e3becda98958225ce0ab3478a8f7fe2584"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a1ea5b8fbae6561a594c3d72706b846a3faaff74ebcf4911bc466f51590bf1b"
    sha256 cellar: :any,                 arm64_ventura: "c6c0edfdc3f68eabb96bdcf755c9f0ead40dc25394ebdd226a4bb348038e7799"
    sha256 cellar: :any_skip_relocation, sonoma:        "5bdab24a2100cf79ef66cf23c90c8f7c5b3c12006a60a14af7a4adae2a211921"
    sha256 cellar: :any,                 ventura:       "9bdc8ca295437ceb51e567998282f24c4b40c82b7a31d07f674f7783e3df80e1"
  end

  depends_on :macos

  uses_from_macos "swift" => :build, since: :sonoma # swift 5.10+

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".build/release/mist"
    generate_completions_from_executable(bin/"mist", "--generate-completion-script")
  end

  test do
    # basic usage output
    assert_match "-h, --help", shell_output("#{bin}/mist").strip

    # check we can export the output list
    out = testpath/"out.json"
    system bin/"mist", "list", "firmware", "--quiet", "--export=#{out}", "--output-type=json"
    assert_path_exists out

    # check that it's parseable JSON in the format we expect
    parsed = JSON.parse(File.read(out))
    assert_kind_of Array, parsed
  end
end

class MistCli < Formula
  desc "Mac command-line tool that automatically downloads macOS Firmwares / Installers"
  homepage "https://github.com/ninxsoft/mist-cli"
  url "https://github.com/ninxsoft/mist-cli/archive/refs/tags/v2.2.tar.gz"
  sha256 "556b0680ea8aec5be5b111a0858c3434765efe6efe3526432ba13d33232d7706"
  license "MIT"
  head "https://github.com/ninxsoft/mist-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a8e66ca77d81b43934d93bb3e970ba85c0c7020536d19aca2048e57405262c1b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "428a8c9a5fd5cc5116421c0e425bd14288398ec2a72e64d7b1bd3a741b8777e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aad7964ffb7a48c142c64e56f134635aa96a2236e7016dbe2a84a09bea870b83"
    sha256 cellar: :any_skip_relocation, sonoma:        "c4657c924d66b94a23d3bb38fbe10e860ea40683dabfcbda2a98177a6f8ce7fc"
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

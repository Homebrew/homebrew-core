class MistCli < Formula
  desc "Mac command-line tool that automatically downloads macOS Firmwares / Installers"
  homepage "https://github.com/ninxsoft/mist-cli"
  url "https://github.com/ninxsoft/mist-cli/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "aec30c9ff043e17ce0e6dd563480bd8015910ea1f110d4b767522e41e92bc00e"
  license "MIT"
  head "https://github.com/ninxsoft/mist-cli.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3de5cfe1043e9d802d578250bf5ec02386c0e1541c8e6bf8c1f57883bb01155"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d52878ebf4acd1c8e3462bc7dc477df052682bef4bd8f696a9f2fa83188d403e"
    sha256 cellar: :any,                 arm64_ventura: "7e304d64f0ef30b675ca7b6fc8df1c3bea09c5f69eaf5cc5ec547d73b9b8a012"
    sha256 cellar: :any_skip_relocation, sonoma:        "7515d36129473828d4ea0272a182ffb8824ac3ed7c5ecdce65b6633289cc500d"
    sha256 cellar: :any,                 ventura:       "485d54f96a0ecb0c3739b310b459007a270587746b0187a596da10f04fbbf3c4"
  end

  depends_on :macos

  uses_from_macos "swift" => :build, since: :sonoma # swift 5.10+

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".build/release/mist"
  end

  test do
    # basic usage output
    assert_match "-h, --help", shell_output("#{bin}/mist").strip

    # check we can export the output list
    out = testpath/"out.json"
    system bin/"mist", "list", "firmware", "--quiet", "--export=#{out}", "--output-type=json"
    assert_predicate out, :exist?

    # check that it's parseable JSON in the format we expect
    parsed = JSON.parse(File.read(out))
    assert_kind_of Array, parsed
  end
end

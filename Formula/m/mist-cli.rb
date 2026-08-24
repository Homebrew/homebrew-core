class MistCli < Formula
  desc "Mac command-line tool that automatically downloads macOS Firmwares / Installers"
  homepage "https://github.com/ninxsoft/mist-cli"
  url "https://github.com/ninxsoft/mist-cli/archive/refs/tags/v2.3.tar.gz"
  sha256 "734bf8305a0005af2032a948689ca66352bcbe99e3779464db3607c17f3d9348"
  license "MIT"
  head "https://github.com/ninxsoft/mist-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "70dcd85adb91b5d8dbf27bd478165394d1011257931c87a40fb338034cf8752d"
    sha256 cellar: :any,                 arm64_sequoia: "be066e457d7d97b51e8c9d3371655df27f04517eb7cb941f41029e68a270f2de"
    sha256 cellar: :any,                 arm64_sonoma:  "a639ca5784dda545f3d11bda4cdf182900f6ac3fa5f3f90e7d2f721bcf9b5304"
    sha256 cellar: :any,                 sonoma:        "e2cd403aeb233f61195083715d32b0e7578a6b700bb9c974d6f896bccb18fa40"
  end

  depends_on :macos

  uses_from_macos "swift" => :build, since: :tahoe # swift 6.3.1+

  on_sonoma :or_older do
    depends_on xcode: ["16.0", :build] # need 15.0+ SDK for __swift_nonisolated_unsafe on __stdoutp
  end

  def install
    system "swift", "build", *std_swift_args
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

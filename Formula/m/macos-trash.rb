class MacosTrash < Formula
  desc "Move files and folders to the trash"
  homepage "https://github.com/sindresorhus/macos-trash"
  url "https://github.com/sindresorhus/macos-trash/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "95eeea2a96e5d989145da4697206062798b9f708101dc426ae5a489969619114"
  license "MIT"
  head "https://github.com/sindresorhus/macos-trash.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2428e281cfd65f72086b510be7e425635e855f4fda1d272964c30b5253a9df4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8aff9fa300a5df44f6659bfc66c7976e79b8e3aee583c22148ee50062517b281"
    sha256 cellar: :any_skip_relocation, sonoma:        "240b1bf992d89a5b41c1f5346188c5059bd5b2ed0ba8c475f7a02310cc299e31"
  end

  keg_only :shadowed_by_macos

  depends_on xcode: ["16.0", :build]
  depends_on :macos
  uses_from_macos "swift", since: :sonoma # Swift 6.0

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/trash"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/trash --version")
    system bin/"trash", "--help"
  end
end

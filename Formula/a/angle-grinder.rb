class AngleGrinder < Formula
  desc "Slice and dice log files on the command-line"
  homepage "https://github.com/rcoh/angle-grinder"
  url "https://github.com/rcoh/angle-grinder/archive/refs/tags/v0.19.4.tar.gz"
  sha256 "13ae3912dcc34c2648d8ef57fe8d976cb978c70e6976ead079ea5d7609532172"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "34bee33321a752ef7c4286f25190b9e052373f87b3010ecb373897639fca9c5a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1f94b6a8db8825e5671af8ea2753012bb1029d54cd94c62cca9bb8b65c8b0823"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7d65579f03d9917cd269ba985805a8d9a35187e316fe7dbdbc555348127e87a9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ff947abe9071113699323e0c2fc94311f5635b05b6729af54e69c56e39106fe"
    sha256 cellar: :any_skip_relocation, sonoma:         "50f0ba886e21fe5768e728f589354d1f578dbab556fd3a1d7a591258f24b09a9"
    sha256 cellar: :any_skip_relocation, ventura:        "22a6b97d5f193e1fe41ae978f0b4c51726b5e1cdd8359d1cc42808c1590a25af"
    sha256 cellar: :any_skip_relocation, monterey:       "16cd61cadfe4ee8355888a61b6fed3f773f3a178cf08a2f563d4e8b460cfdf6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90432e2f65c6230ccf74f297c3bbdae7790796431d753228e9a064d2d62ffc91"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"logs.txt").write("{\"key\": 5}")
    output = shell_output("#{bin}/agrind --file logs.txt '* | json'")
    assert_match "[key=5]", output
  end
end

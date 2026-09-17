# SPDX-License-Identifier: Apache-2.0
# Homebrew formula. Install from this repo:
#
#   brew trust --tap eonik-ai/graft
#   brew tap eonik-ai/graft https://github.com/eonik-ai/graft
#   brew install graft
#
# ffmpeg is a runtime dependency (graft shells out; it does not link x264).
class Graft < Formula
  desc "Change the hook. Keep the body"
  homepage "https://github.com/eonik-ai/graft"
  url "https://github.com/eonik-ai/graft/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "aa736b49bd825eaabcd0d713b3c0e502f794766c1c65cf061d18963daa69bf3b"
  license "Apache-2.0"
  head "https://github.com/eonik-ai/graft.git", branch: "main"

  depends_on "rust" => :build
  depends_on "ffmpeg"

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/graft")
  end

  def caveats
    <<~EOS
      graft shells out to ffmpeg and ffprobe. They are already in this keg's
      dependency tree. Override with $FFMPEG / $FFPROBE if you need a custom build.
    EOS
  end

  test do
    assert_match "graft", shell_output("#{bin}/graft --version")
  end
end

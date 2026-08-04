class BpmFinderApp < Formula
  desc "Audio tempo detection, tap BPM counter, and delay timing calculator"
  homepage "https://bpmfinderapp.com"
  url "https://github.com/nazzal5448/bpm-finder-app/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "12887f0211b6d9582575cb020c29cbfe9f3dc5a2ca9f5aee9acacd0e4235929e"
  license "MIT"

  def install
    bin.install "snapcraft-bpm-finder/bin/bpm-finder-app" => "bpm-finder-app"
  end

  test do
    assert_match "BPM", shell_output("#{bin}/bpm-finder-app 120")
  end
end

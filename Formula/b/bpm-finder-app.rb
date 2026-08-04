class BpmFinderApp < Formula
  desc "Audio tempo detection, tap BPM counter, and delay timing calculator"
  homepage "https://bpmfinderapp.com"
  url "https://github.com/nazzal5448/bpm-finder-app/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
  license "MIT"

  def install
    bin.install "snapcraft-bpm-finder/bin/bpm-finder-app" => "bpm-finder-app"
  end

  test do
    assert_match "BPM", shell_output("#{bin}/bpm-finder-app 120")
  end
end

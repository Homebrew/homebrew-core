class Ktmm < Formula
  desc "Keep That Mouse Moving - Prevents system sleep by making periodic mouse movements"
  homepage "https://github.com/ao/ktmm"
  version "0.2.0"
  license "MIT"

  if Hardware::CPU.arm?
    url "https://github.com/ao/ktmm/releases/download/v#{version}/ktmm-macos-arm64"
    sha256 "7400df454b0f3cf3424ca4c8dda48d35c2620571b8857427abebdb6938c0721e"
  else
    url "https://github.com/ao/ktmm/releases/download/v#{version}/ktmm-macos-x86_64"
    sha256 "0781ab4279e0d7311fdffcb97ff882547ea203cea4ce9adceea18b6be48149e3"
  end

  def install
    if Hardware::CPU.arm?
      bin.install "ktmm-macos-arm64" => "ktmm"
    else
      bin.install "ktmm-macos-x86_64" => "ktmm"
    end
  end

  test do
    system "#{bin}/ktmm", "--version"
  end

  # Add a note about accessibility permissions
  def caveats
    <<~EOS
      KTMM requires accessibility permissions on macOS.
      After installation, go to:
      System Preferences > Security & Privacy > Privacy > Accessibility
      and add KTMM to the list of allowed applications.
    EOS
  end
end
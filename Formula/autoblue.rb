class Autoblue < Formula
  desc "Automatically turning off Bluetooth when the Mac goes to sleep in macOS"
  homepage "https://github.com/atayikilmaz/AutoBlue"
  url "https://github.com/atayikilmaz/AutoBlue/releases/download/v0.1.0/AutoBlue.tar"
  sha256 "82b0594afc16ae87c6b4ef45386293f2eab57264ef6bf1459884d7e475f5452e"
  license "MIT"

  def install
    bin.install "autoblue"
  end

  test do
    # Verify that the 'autoblue' executable exists
    assert_predicate bin/"autoblue", :exist?
    
    # Test running the 'autoblue' command (replace with actual test logic)
    system "#{bin}/autoblue", "--version"
  end

  service do
    run [opt_bin/"autoblue"]
    keep_alive true
  end
end

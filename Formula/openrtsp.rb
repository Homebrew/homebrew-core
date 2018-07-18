class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "http://www.live555.com/liveMedia/public/live.2018.04.25.tar.gz"
  sha256 "bfb72d79cfa42779115dd7e5db705b863e30f7956638407c8637e97cefcf4005"

  bottle do
    cellar :any_skip_relocation
    sha256 "41c7fc0e36e1a59a3ef3534dd9273f99f6c23b9dc21cb40260d30c38bd7eaad7" => :high_sierra
    sha256 "eaae66891ec2e82269fb1b92a9ed205fd831af2962355f72b7a7d6a175659e17" => :sierra
    sha256 "0df18b04b20f54a373d7aa13dfd942cde6178c88a90671e3fc50151deed2fa64" => :el_capitan
  end

  def install
    system "./genMakefiles", "macosx"
    system "make", "PREFIX=#{prefix}", "install"

    # Move the testing executables out of the main PATH
    libexec.install Dir.glob(bin/"test*")
  end

  def caveats; <<~EOS
    Testing executables have been placed in:
      #{libexec}
  EOS
  end

  test do
    assert_match "GNU", shell_output("#{bin}/live555ProxyServer 2>&1", 1)
  end
end

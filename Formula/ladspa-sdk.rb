class LadspaSdk < Formula
  desc "Linux Audio Developer's Simple Plugin"
  homepage "https://ladspa.org"
  url "https://www.ladspa.org/download/ladspa_sdk_1.16.tgz"
  sha256 "511b237dca0f6c7b993f6be0954215c8f859d6f2a20686b25d082458d763e38b"
  license "LGPL-2.1-only"

  livecheck do
    url "https://www.ladspa.org/download/"
    regex(/href=.*?ladspa[._-]sdk[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 x86_64_linux: "3c74d63089423f9b0752a4f8107ea62dbcf132d18cbc925f45addbae1518d2f9"
  end

  depends_on "libsndfile"
  depends_on :linux

  def install
    args = %W[
      INSTALL_PLUGINS_DIR=#{lib}/ladspa
      INSTALL_INCLUDE_DIR=#{include}
      INSTALL_BINARY_DIR=#{bin}
    ]
    cd "src" do
      system "make", "install", *args
    end
    bin.env_script_all_files libexec/"bin", LADSPA_PATH: opt_lib/"ladspa"
  end

  test do
    output = shell_output("#{bin}/listplugins")
    assert_match "Mono Amplifier", output
    assert_match "Simple Delay Line", output
    assert_match "Simple Low Pass Filter", output
    assert_match "Simple High Pass Filter", output
    assert_match "Sine Oscillator", output
    assert_match "Stereo Amplifier", output
    assert_match "White Noise Source", output

    expected_output = <<~EOS
      Plugin Name: "Mono Amplifier"
      Plugin Label: "amp_mono"
      Plugin Unique ID: 1048
      Maker: "Richard Furse (LADSPA example plugins)"
      Copyright: "None"
      Must Run Real-Time: No
      Has activate() Function: No
      Has deactivate() Function: No
      Has run_adding() Function: No
      Environment: Normal or Hard Real-Time
    EOS
    assert_match expected_output, shell_output("#{bin}/analyseplugin amp")
  end
end

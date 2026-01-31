class LitraAutotoggle < Formula
  desc "Automatically turn your Logitech Litra device on when your webcam turns on, and off when your webcam turns off"
  homepage "https://github.com/timrogers/litra-autotoggle"
  url "https://github.com/timrogers/litra-autotoggle/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "bd5957e2c51b2a95da6af44c43076bcd75ee8f472f2cda98a872c98f4730f3ed"
  license "MIT"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "hidapi"
    depends_on "openssl@3"
    depends_on "systemd"
  end

  def install
    system "cargo", "install", *std_cargo_args
    etc.install 'litra-autotoggle.example.yml' => 'litra-autotoggle.yml'
  end

  def caveats
    <<~EOS
      To start litra-autotoggle in the background as a service, run:
        brew services start litra-autotoggle

      To customize the options for the background service, edit the configuration file:
        #{etc}/litra-autotoggle.yml
    EOS
  end

  service do
    run [opt_bin / 'litra-autotoggle', '--config', etc / 'litra-autotoggle.yml']
    keep_alive crashed: true
  end

  test do
    assert_match "No Litra devices found", shell_output("#{bin}/litra-autotoggle").strip
  end
end

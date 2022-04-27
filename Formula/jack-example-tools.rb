class JackExampleTools < Formula
  desc "Example clients and tools for JACK"
  homepage "https://jackaudio.org/"
  url "https://github.com/jackaudio/jack-example-tools/archive/3.tar.gz"
  sha256 "661a95d43c276d444b03756564ceaa3b53a2a0b78c8147631383f31fa85135c6"
  license "GPL-2.0-or-later"
  head "https://github.com/jackaudio/jack-example-tools.git", branch: "main"

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "jack"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja", "-v"
      system "ninja", "-v", "install"
    end
  end

  test do
    source_name = "test_source"
    sink_name = "test_sink"
    fork do
      if OS.mac?
        exec "#{Formula["jack"].bin}/jackd", "-X", "coremidi", "-d", "dummy"
      else
        exec "#{Formula["jack"].bin}/jackd", "-d", "dummy"
      end
    end
    system "#{bin}/jack_wait", "--wait", "--timeout", "10"
    fork do
      exec "#{bin}/jack_midiseq", source_name, "16000", "0", "60", "8000"
    end
    midi_sink = IO.popen "#{bin}/jack_midi_dump #{sink_name}"
    sleep 1
    system "#{bin}/jack_connect", "#{source_name}:out", "#{sink_name}:input"
    sleep 1
    Process.kill "TERM", midi_sink.pid

    midi_dump = midi_sink.read
    assert_match "90 3c 40", midi_dump
    assert_match "80 3c 40", midi_dump
  end
end

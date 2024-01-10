class Portshield < Formula
  desc "Close opened ports (running processes) easily from CLI"
  homepage "https://github.com/ikotun-dev/port.shield"
  url "https://github.com/ikotun-dev/port.shield/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "b48f680902f9404da59f1b5598d2879cd2e637627fadd9c0a4b4a5dfb4bb100a"
  license "MIT"

  depends_on "python@3.11"

  def install
    bin.install "main.py" => "portshield"
  end

  test do
    output = IO.popen("#{bin}/portshield", "r+") do |pipe|
      pipe.puts "k"
      pipe.puts "8080"
      pipe.puts "y"
      pipe.close_write

      pipe.read
    end
    assert_match "Process with PID", output
  end
end

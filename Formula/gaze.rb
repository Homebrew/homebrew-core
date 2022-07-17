class Gaze < Formula
  desc "Execute commands for you"
  homepage "https://github.com/wtetsu/gaze"
  url "https://github.com/wtetsu/gaze/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "02bac4bfeded4e8e951af2d255a26ea3554dbbf4fd124cc9cfad5e29265e0a4d"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "dist/gaze", "-v", "cmd/gaze/main.go"
    bin.install "dist/gaze"
  end

  test do
    (testpath/"test.txt").write("init")
    o = IO.popen("#{bin}/gaze -c 'cp test.txt out.txt' test.txt")
    thread = Thread.new do
      10.times do
        begin
          File.write("test.txt", "hello, world!")
        rescue
          # Safe to ignore
        end
        sleep 1
      end
    end
    10.times do
      break if File.exist?("out.txt")

      sleep 1
    end
    thread.terminate
    assert("hello, world!", File.read("out.txt"))
    Process.kill("TERM", o.pid)
  end
end

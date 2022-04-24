class Bartib < Formula
  desc "Simple timetracker for the command-line"
  homepage "https://github.com/nikolassv/bartib"
  url "https://github.com/nikolassv/bartib/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "51ee91f0ebcdba8a3e194d1f800aab942d99b1be1241d9d29f85615a89c87e6e"
  license "GPL-3.0-only"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    bartib_file = testpath/"activities.bartib"
    touch bartib_file
    ENV["BARTIB_FILE"] = bartib_file

    system bin/"bartib", "start", "-d", "task BrewTest", "-p", "project"
    sleep 2
    system bin/"bartib", "stop"
    expected =<<~EOS.strip
      \e[1mproject.......... 0s\e[0m
          task BrewTest 0s

      \e[1mTotal............ 0s\e[0m
    EOS
    assert_equal expected, shell_output(bin/"bartib report").strip
  end
end

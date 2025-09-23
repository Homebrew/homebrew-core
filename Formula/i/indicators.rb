class Indicators < Formula
  desc "Activity indicators for modern C++"
  homepage "https://github.com/p-ranav/indicators"
  url "https://github.com/p-ranav/indicators/archive/refs/tags/v2.3.tar.gz"
  sha256 "70da7a693ff7a6a283850ab6d62acf628eea17d386488af8918576d0760aef7b"
  license "MIT"
  head "https://github.com/p-ranav/indicators.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "2322751e34abbf99f523edd2f22119089ce3ce2935ffc919e6ba6c2e2b6f72bc"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <indicators/cursor_control.hpp>
      #include <indicators/progress_bar.hpp>
      #include <vector>
      int main() {
        using namespace indicators;
        show_console_cursor(false);
        indicators::ProgressBar p;
        p.set_option(option::BarWidth{0});
        p.set_option(option::PrefixText{"Brewing... "});
        p.set_option(option::Start{""});
        p.set_option(option::Fill{""});
        p.set_option(option::Lead{""});
        p.set_option(option::Remainder{""});
        p.set_option(option::End{""});
        p.set_option(option::ForegroundColor{indicators::Color::white});
        p.set_option(option::ShowPercentage{false});
        p.set_option(
            option::FontStyles{std::vector<indicators::FontStyle>{indicators::FontStyle::bold}});
        auto job = [&p]() {
          while (true) {
            p.set_option(
                option::PrefixText{"Brewing... " + std::to_string(p.current()) + "% "});
            if (p.current() + 1 > 100)
              p.set_option(option::PrefixText{"Brewing... Done"});
            p.tick();
            if (p.is_completed()) {
              break;
            }
            std::this_thread::sleep_for(std::chrono::milliseconds(10));
          }
        };
        std::thread thread(job);
        thread.join();
        show_console_cursor(true);
        return 0;
      }
    CPP

    system ENV.cxx, "test.cpp", "-std=c++11", "-I#{include}", "-o", "test"
    output = shell_output("./test")

    assert_equal output.scan(/(?=Brewing...)/).count, 100
    100.times do |n|
      assert_match "#{n}%", output
    end
  end
end

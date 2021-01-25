class Indicators < Formula
  desc "Activity indicators for modern C++"
  homepage "https://github.com/p-ranav/indicators"
  url "https://github.com/p-ranav/indicators/archive/v2.0.tar.gz"
  sha256 "ef296fa614edcd798db0ac6c3c0f2990682cae8b83724a4db34eed17521c75f7"
  license "MIT"
  head "https://github.com/p-ranav/indicators.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e28a931aa3e3214dd163a00769f36e9a24a9eb4e6fbff71ec0afcf19698a7691" => :big_sur
    sha256 "03391b82e5e3990b57abd63397645728c20fc574a2a6b2d59622fe501b5a2ef5" => :arm64_big_sur
    sha256 "fadf29d80558d33ced6d4a2bb5777685849feaeab3343dc27aebc580c9a01a94" => :catalina
    sha256 "7c456f073e1634a70e558b8c05534cba357f2415f793fd16a1a020c75e012ef0" => :mojave
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
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
    EOS
    system ENV.cxx, "test.cpp", "-std=c++11", "-I#{include}", "-o", "test"
    output = shell_output("./test")

    assert_equal output.scan(/(?=Brewing...)/).count, 100
    (0..99).each do |n|
      assert_match "#{n}%", output
    end
  end
end

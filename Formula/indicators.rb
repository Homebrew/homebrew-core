class Indicators < Formula
  desc "Activity indicators for modern C++"
  homepage "https://github.com/p-ranav/indicators"
  url "https://github.com/p-ranav/indicators/archive/v2.2.tar.gz"
  sha256 "b768f1b7ca64a413503f72d5460cc617c1458c17fb7a8c0ee503d753e1f20d03"
  license "MIT"
  head "https://github.com/p-ranav/indicators.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "60d4242ee3f9af21462bd6416eb0250a24109ef6a15e55904cedccd9a1dff42e"
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
    100.times do |n|
      assert_match "#{n}%", output
    end
  end
end

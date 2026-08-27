class Exprtk < Formula
  desc "C++ Mathematical Expression Parsing And Evaluation Library"
  homepage "https://www.partow.net/programming/exprtk/index.html"
  url "https://github.com/ArashPartow/exprtk/archive/refs/tags/0.0.3.tar.gz"
  sha256 "f9dec6975e86c702033d6a65ba9a0368eba31a61b89d74f2b5d24457c02c8439"
  license "MIT"
  head "https://github.com/ArashPartow/exprtk.git", branch: "master"

  def install
    include.install "exprtk.hpp"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include "exprtk.hpp"
      #include <cmath>
      int main()
      {
        exprtk::symbol_table<double> symbol_table;
        const std::string expression_string = "clamp(-1.0, sin(2 * pi * x) + cos(x / 2 * pi), +1.0)";
        double x;
        symbol_table.add_variable("x",x);
        symbol_table.add_constants();
        exprtk::expression<double>   expression;
        expression.register_symbol_table(symbol_table);
        exprtk::parser<double>       parser;
        parser.compile(expression_string,expression);
        x = 0.;
        const double y = expression.value();
        if (std::abs(y - 1.) > 1e-6)
          return 1;
        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp",
           "-o", "test"
    system "./test"
  end
end

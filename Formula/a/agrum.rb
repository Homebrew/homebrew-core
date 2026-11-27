class Agrum < Formula
  desc "C++ Library for Probabilistic Graphical Models"
  homepage "https://pyagrum.gitlab.io/agrum/"
  url "https://gitlab.com/agrumery/aGrUM/-/archive/3.4.0/aGrUM-3.4.0.tar.bz2"
  sha256 "d994070f09efd43617c4ccead9c38e9f937913bd37bc40dc2cdfacc4a09eed7d"
  license "LGPL-3.0-or-later"
  head "https://gitlab.com/agrumery/aGrUM.git", branch: "master"

  depends_on "cmake" => :build

  deny_network_access!

  def install
    args = %W[
      -DCMAKE_UNITY_BUILD=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <agrum/BN/BayesNet.h>
      #include <agrum/BN/inference/lazyPropagation.h>
      #include <iostream>
      int main() {
        auto bn = gum::BayesNet<float>();
        auto a = bn.add(gum::LabelizedVariable("A", "", 2));
        auto b = bn.add(gum::LabelizedVariable("B", "", 2));
        bn.addArc(a, b);
        bn.cpt(a).fillWith({0.3f, 0.7f});
        bn.cpt(b).fillWith({0.9f, 0.1f, 0.2f, 0.8f});
        gum::LazyPropagation<float> inf(&bn);
        inf.makeInference();
        std::cout << inf.posterior(b) << std::endl;
        return 0;
      }
    CPP
    system ENV.cxx, "-std=c++20", "test.cpp",
           "-I#{include}", "-L#{lib}", "-lagrumBN", "-lagrumBASE",
           "-Wl,-rpath,#{lib}", "-o", "test"
    output = shell_output("./test")
    assert_match "0.41", output
    assert_match "0.59", output
  end
end

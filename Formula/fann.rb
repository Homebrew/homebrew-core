class Fann < Formula
  desc "Fast artificial neural network library"
  homepage "https://sourceforge.net/projects/fann"
  url "https://downloads.sourceforge.net/project/fann/fann/2.2.0/FANN-2.2.0-Source.tar.gz"
  sha256 "3d6ee056dab91f3b34a3f233de6a15331737848a4cbdb4e0552123d95eed4485"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "dd693aef10b32db6fe84a9eabfbd1e05c1d4ed83c4e48e936745fa76b2af7a4f"
    sha256 cellar: :any,                 arm64_big_sur:  "2fc8447731fd2a1c7f4957b55e3906041796fd5c9c528c611048f48558e644fc"
    sha256 cellar: :any,                 monterey:       "468d340a979831b709a4a67defc13796a7763019836d15d98f723aa1b8cb1981"
    sha256 cellar: :any,                 big_sur:        "4d7d975ad6d820ce4938ba6235881b11cfebb93ad8f5ac4cb5dabf2356f2ffa0"
    sha256 cellar: :any,                 catalina:       "61d506a68652f81b0f93120b7ed1fb049510f18381e35a52abe52f0170e589a6"
    sha256 cellar: :any,                 mojave:         "f4ff7eaa67aad30f4c544b3c9e20d4b4f9204807d97b900004ec65a27a2b6175"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1596e86f9b80da14fc97d5841253dc22c3ffe2e47991ef0c161d4512ef72f65d"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"xor.data").write <<~EOS
      4 2 1
      -1 -1
      -1
      -1 1
      1
      1 -1
      1
      1 1
      -1
    EOS

    desired_error = 0.001
    max_epochs = 500000

    (testpath/"test.c").write <<~EOS
      #include <fann.h>
      int main()
      {
          const unsigned int num_input = 2;
          const unsigned int num_output = 1;
          const unsigned int num_layers = 3;
          const unsigned int num_neurons_hidden = 3;
          const float desired_error = (const float) #{desired_error};
          const unsigned int max_epochs = #{max_epochs};
          const unsigned int epochs_between_reports = 1000;
          struct fann *ann = fann_create_standard(num_layers, num_input,
              num_neurons_hidden, num_output);
          fann_set_activation_function_hidden(ann, FANN_SIGMOID_SYMMETRIC);
          fann_set_activation_function_output(ann, FANN_SIGMOID_SYMMETRIC);
          fann_train_on_file(ann, "xor.data", max_epochs,
              epochs_between_reports, desired_error);
          fann_save(ann, "xor_float.net");
          fann_destroy(ann);
          return 0;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lfann", "-lm", "-o", "test"
    output = shell_output(testpath/"test")
    epoch, error = output.lines.last.match(/Epochs\s+(\d+)\.\s+Current error:\s+(\d+\.\d+)\. Bit fail 0\./).captures

    assert epoch.to_i <= max_epochs
    assert error.to_f <= desired_error
    assert_predicate testpath/"xor_float.net", :exist?
  end
end

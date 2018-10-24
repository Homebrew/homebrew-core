class Minizinc < Formula
  desc "Medium-level constraint modeling language"
  homepage "https://www.minizinc.org/"
  url "https://github.com/MiniZinc/libminizinc/archive/2.2.1.tar.gz"
  sha256 "b1069e4b5382cead00f3df20122f24a5f96fafec5bd1b09d76ad5748703c6ea5"
  head "https://github.com/MiniZinc/libminizinc.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "1ee18e5d17275ee302f146b7f34522cb7c454bbefec2a900c4d01b416038aa76" => :mojave
    sha256 "f9a4a08311223b96f1ab8f7ee1dd7a5f486f855beaac70ee6dc645a8524bdfba" => :high_sierra
    sha256 "5686d26dd8a031e1887b33c77ddd16408dd7926cbb0ef42196ac120fceb19e98" => :sierra
  end

  depends_on "cmake" => :build
  depends_on :arch => :x86_64

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "cmake", "--build", ".", "--target", "install"
    end
  end

  test do
    system bin/"mzn2doc", share/"examples/functions/warehouses.mzn"
  end
end

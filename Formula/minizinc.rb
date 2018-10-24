class Minizinc < Formula
  desc "Medium-level constraint modeling language"
  homepage "https://www.minizinc.org/"
  url "https://github.com/MiniZinc/libminizinc/archive/2.2.1.tar.gz"
  sha256 "b1069e4b5382cead00f3df20122f24a5f96fafec5bd1b09d76ad5748703c6ea5"
  head "https://github.com/MiniZinc/libminizinc.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "17361a41e5e22f55b6b78cc59c198f728f0b75bb8532552c0e6fcb54b6ed3636" => :mojave
    sha256 "ef4e7b7bc78c1a2f7ab3884bc84df61dcca526b1c52c9c85fc4d52abfc1f3aa9" => :high_sierra
    sha256 "131cd946650fb81e4f5c70126c73c3e1ff0a81c9656a0de1c07c48fe8e35cb84" => :sierra
    sha256 "806dfb571c83b5ad4028098455ac5e277c5c0437cddbbd50e5dd2c54b87ac19c" => :el_capitan
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

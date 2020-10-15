class Minizinc < Formula
  desc "Medium-level constraint modeling language"
  homepage "https://www.minizinc.org/"
  url "https://github.com/MiniZinc/libminizinc/archive/2.5.0.tar.gz"
  sha256 "a92be5e1f0d7a2d7177341650cbb976114aa4e1e2f260b1e9dada28ebf044b30"
  license "MPL-2.0"
  head "https://github.com/MiniZinc/libminizinc.git", branch: "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "3761bf1a5f715d47c2292fa0e71d5edaf66dc5d18362952a19c9ab61bdb5f4dd" => :catalina
    sha256 "10169d25a64dd162ac28aaccd6296efaa084c380942115c0ce7ba17ac7a0ffc7" => :mojave
    sha256 "ea375d5c130fa16354d6b48c01aa32752593da13526afabab3bf3e79c93953f7" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on arch: :x86_64

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "cmake", "--build", ".", "--target", "install"
    end
  end

  test do
    system bin/"mzn2doc", pkgshare/"std/all_different.mzn"
  end
end

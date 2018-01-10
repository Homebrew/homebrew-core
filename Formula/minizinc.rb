class Minizinc < Formula
  desc "Medium-level constraint modeling language"
  homepage "http://www.minizinc.org"
  url "https://github.com/MiniZinc/libminizinc/archive/2.1.7.tar.gz"
  sha256 "e59075bbdcc36821d757b3b3fff288f341a0d30ce63dc253cc26ade55292657d"
  head "https://github.com/MiniZinc/libminizinc.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "acd6f237e40072b2551f5a5a17ecd96d6f52f1f98ea5f7e84c895b91b582b3da" => :high_sierra
    sha256 "a54e076b9223a55b932d359489e8ba9ea4a3fb45eb9093ad250536f41a20768b" => :sierra
    sha256 "46b16382dd7b639d0e19de5c1a735078bafee8f6df51dbedd0d82332cf0edaae" => :el_capitan
  end

  depends_on :arch => :x86_64
  depends_on "cmake" => :build

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

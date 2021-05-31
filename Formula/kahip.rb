class Kahip < Formula
  desc "Karlsruhe High Quality Partitioning"
  homepage "https://algo2.iti.kit.edu/documents/kahip/index.html"
  url "https://github.com/KaHIP/KaHIP/archive/v3.10.tar.gz"
  sha256 "d58dc08f0205373d1a811b888c6db5192deeb3271f056daf2fc9ba89654832c5"
  license "MIT"
  head "https://github.com/KaHIP/KaHIP.git"

  bottle do
    sha256               arm64_big_sur: "e9d713bb93fbe49d1bcef25f867e4ba614eb8549cbc8e3133db97b1cfa2585cd"
    sha256 cellar: :any, big_sur:       "c4d19fd4c333aaebe84872bc9f6a35df09b0a6f5d419a527897f91c516b325d1"
    sha256 cellar: :any, catalina:      "4c49f840a133a8a9dcdf242ebb774e4a2830afb734eac61a2d90b0c6d5a5ab95"
    sha256 cellar: :any, mojave:        "adbfc7c1b88eb8e78c842c19ccdfd5a0707eac0cf891576303bf779c1204cd43"
  end

  depends_on "cmake" => :build
  depends_on "open-mpi"

  on_macos do
    depends_on "gcc"
  end

  def install
    on_macos do
      gcc_major_ver = Formula["gcc"].any_installed_version.major
      ENV["CC"] = Formula["gcc"].opt_bin/"gcc-#{gcc_major_ver}"
      ENV["CXX"] = Formula["gcc"].opt_bin/"g++-#{gcc_major_ver}"
    end

    mkdir "build" do
      system "cmake", *std_cmake_args, ".."
      system "make", "install"
    end
  end

  test do
    output = shell_output("#{bin}/interface_test")
    assert_match "edge cut 2", output
  end
end

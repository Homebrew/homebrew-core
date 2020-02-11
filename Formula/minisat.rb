class Minisat < Formula
  desc "Boolean satisfiability (SAT) problem solver"
  homepage "http://minisat.se"

  head "https://github.com/stp/minisat.git", :branch => "master"

  stable do
    url "https://github.com/stp/minisat/archive/releases/2.2.1.tar.gz"
    sha256 "432985833596653fcd698ab439588471cc0f2437617d0df2bb191a0252ba423d"
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "-DSTATIC_BINARIES=ON",
                      "-DCMAKE_INSTALL_PREFIX=#{prefix}",
                      ".."
      system "make"
      system "make", "install"
    end
  end

  test do
    dimacs = <<~EOS
      p cnf 3 2
      1 -3 0
      2 3 -1 0
    EOS

    assert_match(/^SATISFIABLE$/, pipe_output("#{bin}/minisat", dimacs, 10))
  end
end

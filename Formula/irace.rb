class Irace < Formula
  desc "Iterated Racing for Automatic Algorithm Configuration"
  homepage "https://iridia.ulb.ac.be/irace"
  url "https://cran.r-project.org/src/contrib/irace_3.4.1.tar.gz"
  sha256 "7eea92ba42e6ba320fa8bdca3c53091ae42f26a0f097244f65e7e117f6d514b6"
  license "GPL-2.0-or-later"

  depends_on "r"

  resource "R6" do
    url "https://cran.r-project.org/src/contrib/R6_2.5.1.tar.gz"
    sha256 "8d92bd29c2ed7bf15f2778618ffe4a95556193d21d8431a7f75e7e5fc102bf48"
  end

  def install
    mkdir "#{lib}/R/#{Formula["r"].version.major_minor}/site-library"

    resource("R6").stage do
      system "R", "CMD", "INSTALL", ".", "--library=#{lib}/R/#{Formula["r"].version.major_minor}/site-library"
    end
    system "R", "CMD", "INSTALL", ".", "--library=#{lib}/R/#{Formula["r"].version.major_minor}/site-library"
    bin.install Dir["#{lib}/R/#{Formula["r"].version.major_minor}/site-library/irace/bin/*"]
  end

  test do
    scenario = testpath/"scenario.txt"
    scenario.write <<~EOS
      execDir = "./"
      targetRunner = "target-runner"
      parameterFile = "parameters.txt"
      trainInstancesDir = "instances"
      maxExperiments = 100
    EOS

    target_runner = testpath/"target-runner"
    target_runner.write <<~EOS
      N=$6
      echo $N
    EOS

    parameters = testpath/"parameters.txt"
    parameters.write <<~EOS
      n "-n " r (2, 4)
    EOS

    instances = testpath/"instances"/"1.txt"
    instances.write <<~EOS
      1000
    EOS

    chmod "+x", target_runner

    system bin/"irace"
    assert_predicate testpath/"irace.Rdata", :exist?
  end
end

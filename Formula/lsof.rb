class Lsof < Formula
  desc "Utility to list open files"
  homepage "https://github.com/lsof-org/lsof"
  url "https://github.com/lsof-org/lsof/archive/4.95.0.tar.gz"
  sha256 "8ff4c77736cc7d9556da9e2c7614cc4292a12f1979f20bd520d3c6f64b66a4d7"
  license "Zlib"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca6a2618c47390c2c21a77eafef3fcefa7f139df3a3148f33e147aa1508adc91"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c691f9b32a92b4da66a0b0936317604e7f9861bfc2b3bf82fc5969e9c355bb01"
    sha256 cellar: :any_skip_relocation, monterey:       "86f1ed5ca097d51d5484e3e935270076f9f118aac8dff9918c14c29333663730"
    sha256 cellar: :any_skip_relocation, big_sur:        "2ad5bdb2879e358fb7b268b667068552f8068a0d6b1df02d9b8c134ab1d3b68c"
    sha256 cellar: :any_skip_relocation, catalina:       "5756f095537745ba7e2782a36636779965af3a4bb911c03c0fa46b3dad88ae50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "905f85033932bae924e52ba4b3cd8a1288901686df6b28a376a60c7db5442ff3"
  end

  keg_only :provided_by_macos

  def install
    if OS.mac?
      ENV["LSOF_INCLUDE"] = MacOS.sdk_path/"usr/include"

      # Source hardcodes full header paths at /usr/include
      inreplace %w[
        dialects/darwin/kmem/dlsof.h
        dialects/darwin/kmem/machine.h
        dialects/darwin/libproc/machine.h
      ], "/usr/include", MacOS.sdk_path/"usr/include"
    end

    ENV["LSOF_CC"] = ENV.cc
    ENV["LSOF_CCV"] = ENV.cxx

    mv "00README", "README"
    system "./Configure", "-n", OS.kernel_name.downcase

    system "make"
    bin.install "lsof"
    man8.install "Lsof.8"
  end

  test do
    (testpath/"test").open("w") do
      system "#{bin}/lsof", testpath/"test"
    end
  end
end

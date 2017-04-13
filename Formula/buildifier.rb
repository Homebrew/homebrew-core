class Buildifier < Formula
  desc "Format bazel BUILD files with a standard convention"
  homepage "https://github.com/bazelbuild/buildifier"
  url "https://github.com/bazelbuild/buildifier/archive/0.4.5.tar.gz"
  sha256 "7a732ea12d88ddbf9adc99ff5b5c39bfda53b6286ecc79c3bc082d5f53f46f44"

  bottle do
    cellar :any_skip_relocation
    sha256 "dbb4f613dcc9f616b5b382b14bb433f332c7d1136adabda5ba13b6a77a6f227e" => :sierra
    sha256 "8802021f54c7df51e4a9fcac474da3478cd445fcedb9ca0b3c9c297c7cf39a7e" => :el_capitan
    sha256 "f9124c3d186c89e8f27482e3d3e7195f13df7b5400ccda4117dd36c617f9e711" => :yosemite
  end

  depends_on "bazel" => :build

  def install
    system "bazel", "build", "//buildifier"
    bin.install "bazel-bin/buildifier/buildifier" => "buildifier"
  end

  test do
    touch testpath/"BUILD"
    system "#{bin}/buildifier", "-mode=check", "BUILD"
  end
end

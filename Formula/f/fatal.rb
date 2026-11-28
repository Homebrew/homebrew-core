class Fatal < Formula
  desc "Facebook Template Library"
  homepage "https://www.facebook.com/groups/libfatal/"
  url "https://github.com/facebook/fatal/archive/refs/tags/v2026.09.14.00.tar.gz"
  sha256 "da43cabebbe0a1b279f5eaf3fe7d3460ed7320887ca033d805b84079bc29e3a1"
  license "BSD-3-Clause"
  head "https://github.com/facebook/fatal.git", branch: "main"

  bottle do
    manifest_sha256 "e5afb7bd524e6acac97499897f2224614e42a11f51c64c37be16116490ab1987"
    sha256 cellar: :any_skip_relocation, all: "00f4a4f24af792f102425ba6e653b99c3add770fd1106abf0053b44939325b34"
  end

  deprecate! date: "2026-09-27", because: :repo_archived
  disable! date: "2027-03-27", because: :repo_archived

  def install
    rm "fatal/.clang-tidy"
    include.install "fatal"
    pkgshare.install "demo", "lesson", *buildpath.glob("*.sh")
    inreplace "README.md" do |s|
      s.gsub!("(lesson/)", "(share/fatal/lesson/)")
      s.gsub!("(demo/)", "(share/fatal/demo/)")
    end
  end

  test do
    system ENV.cxx, "-std=c++14", "-I#{include}",
                    include/"fatal/benchmark/test/benchmark_test.cpp",
                    "-o", "benchmark_test"
    system "./benchmark_test"
  end
end

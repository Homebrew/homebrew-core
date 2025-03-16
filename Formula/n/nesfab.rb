class Nesfab < Formula
  desc "Programming language that targets the Nintendo Entertainment System"
  homepage "https://pubby.games/nesfab.html"
  # for this version only, point to a specific commit. post-1.6, this will point to a tagged release.
  url "https://github.com/pubby/nesfab/archive/da18a43dc7b941cc4c56c949303aa37633fdc1b0.tar.gz"
  version "1.6"
  sha256 "bfd8c497df0d87138fda9e5de61d1ab5a36fb1951eeaed413b6619032b711745"
  license "GPL-3.0-only"

  depends_on "make" => :build
  depends_on "boost"
  # the libc++ on Ventura is missing C++20 features this codebase depends on
  depends_on macos: :sonoma
  on_linux do
    depends_on "gcc" => :build
  end

  fails_with :clang do
    build 1599
    cause "Missing std::lexicographical_compare_three_way"
  end

  def install
    # update this when bumping package version
    git_sha = "da18a43d"

    if OS.mac?
      system "make", "GIT_COMMIT=#{git_sha}-homebrew", "CXX=#{ENV.cxx}", "release" if Hardware::CPU.intel?
      system "make", "GIT_COMMIT=#{git_sha}-homebrew", "CXX=#{ENV.cxx}", "ARCH=", "release" if Hardware::CPU.arm?
      bin.install "nesfab" => "nesfab-release"

      system "make", "clean"
      system "make", "GIT_COMMIT=#{git_sha}-homebrew", "CXX=#{ENV.cxx}", "debug" if Hardware::CPU.intel?
      system "make", "GIT_COMMIT=#{git_sha}-homebrew", "CXX=#{ENV.cxx}", "ARCH=", "debug" if Hardware::CPU.arm?
      bin.install "nesfab"
    else
      system "make", "GIT_COMMIT=#{git_sha}-homebrew", "release" if Hardware::CPU.intel?
      system "make", "GIT_COMMIT=#{git_sha}-homebrew", "ARCH=", "release" if Hardware::CPU.arm?
      bin.install "nesfab" => "nesfab-release"

      system "make", "clean"
      system "make", "GIT_COMMIT=#{git_sha}-homebrew", "debug" if Hardware::CPU.intel?
      system "make", "GIT_COMMIT=#{git_sha}-homebrew", "ARCH=", "debug" if Hardware::CPU.arm?
      bin.install "nesfab" => "nesfab"
    end
  end

  test do
    system bin/"nesfab", "--version"
  end
end

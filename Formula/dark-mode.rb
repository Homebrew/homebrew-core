class DarkMode < Formula
  desc "Control the macOS dark mode from the command-line"
  homepage "https://github.com/sindresorhus/dark-mode"
  url "https://github.com/sindresorhus/dark-mode/archive/2.0.1.tar.gz"
  sha256 "edea2a21e550194204bc54fe7f68d32dcc517138ac3b12cb17855e61c3260c68"
  head "https://github.com/sindresorhus/dark-mode.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ef437b437412883b2fb50e72e717b30a3866c5f830e0cd07470b1e791244da9c" => :mojave
    sha256 "fed4e173519d0fdb46694322689ea170c8478b721c045a8f706876d8805aad41" => :high_sierra
    sha256 "ffc564c30ebfa6b2f90600524beacaf3741147407a9c8167c0f5c7b324e05036" => :sierra
    sha256 "7557075bff978e306c392f81e713d987147ef8433da753656c8569de17611879" => :el_capitan
  end

  depends_on :xcode => :build
  depends_on :macos => :el_capitan

  def install
    system "./build"
    bin.install "bin/dark-mode"
  end

  test do
    system "#{bin}/dark-mode", "--version"
  end
end

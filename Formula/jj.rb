class Jj < Formula
  desc "Git-compatible distributed version control system"
  homepage "https://github.com/martinvonz/jj"
  url "https://github.com/martinvonz/jj/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "85e73cde738a2b92aeb253ee3a29f113589c19ad11d4244a14e2d0ca5fbfb3c7"
  license "Apache-2.0"
  head "https://github.com/martinvonz/jj.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "dc667fbd331ce300dc66133f827563c1d6b472dc520e3eb57891e988a3038e71"
    sha256 cellar: :any,                 arm64_monterey: "14e15b3a4ea7ebb0683c8e74f02df616e554c9398a4cc0cb11cba99376568b2a"
    sha256 cellar: :any,                 arm64_big_sur:  "2ef0c4a0976ee49e4d9715d71ed16e56eb1c1bc25811313480d0de796442a9e7"
    sha256 cellar: :any,                 ventura:        "4e3211505da8ee088b04338b3421916e5dec566a51a301ee2c4edde4f0d724ee"
    sha256 cellar: :any,                 monterey:       "4537608628a5842cbad67a8c25e844850c177ec21e2039c38e63dd5a8d74d769"
    sha256 cellar: :any,                 big_sur:        "022107fad21298c3135da11acccbda2c495cb9fc47993801e06d5619afbd9b2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38cf6ecda27eee009e7c40605657f6aa66c33f1d8d9d293a7dd6ba80cc446ae3"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"
  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", "--no-default-features", "--bin", "jj", *std_cargo_args
    generate_completions_from_executable(bin/"jj", "debug", "completion", shell_parameter_format: :flag)
  end

  test do
    system bin/"jj", "init", "--git"
    assert_predicate testpath/".jj", :exist?
  end
end

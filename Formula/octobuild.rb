class Octobuild < Formula
  desc "Compiler cache for Unreal Engine"
  homepage "https://github.com/octobuild/octobuild"
  url "https://github.com/octobuild/octobuild/archive/refs/tags/0.5.3.tar.gz"
  sha256 "fc7b437edde217a43883c56228f95d945b4e7b5bfafb521c0061b20ef21671cc"
  license "MIT"
  head "https://github.com/octobuild/octobuild.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ba01c3136a8a9aff1379a587f1b0ce797f380fabb9d1500b600d0765b7b638b1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6f42f24e57d3a09e46eada290ec0943931da5260b77996360f11245ef77780d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "09b698acdff5e9c6b0da9d359e927d64d568d773dcb6a22ccd96d4e8db5a2210"
    sha256 cellar: :any_skip_relocation, ventura:        "5bc3b49ec14f2cfe4393376d93d295f62bb8a90ab4b9dac3ec5d3badc881bf97"
    sha256 cellar: :any_skip_relocation, monterey:       "7cf06c938d9dd3657c92d62fbd77164697c4fd914a2615cf4791e150e909c424"
    sha256 cellar: :any_skip_relocation, big_sur:        "4ab607c636931bbdf5271edcf62a183dfd04d91efdb87f44c44bdc0b99559f73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bfe9a0603211ce9ba13f2cfe8fc7cfa51679e8a3501ef4ce931e9b0a39c9a3d9"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output bin/"xgConsole"
    assert_match "Current configuration", output
    assert_match "cache_limit_mb", output
  end
end

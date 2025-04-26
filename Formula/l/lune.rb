class Lune < Formula
  desc "Standalone Luau script runtime"
  homepage "https://lune-org.github.io/docs"
  url "https://github.com/lune-org/lune/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "7b286b52fde80f21b350f9043aa8bdc8da05111e52b606dcbaa4a0daf14a793c"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce896cbb34ed606a14eacd9629f461ddf8df45af36b3d0ed12ddd46ee3739c69"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a376a9b70e9b0d41ec1b6566d83758cda2dfce940d1255264b934d86ad3c148b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5fdc05f160a95d1fd52531ed79dddfe6240c70b38fcfb032a1f54c9aa8adbed2"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c0710aa27d7c6a01b915c22a4028275aac8e409ffb7abe45e4ac7d5fffa254a"
    sha256 cellar: :any_skip_relocation, ventura:       "6c4e0ac8adb4896150dcad5831a32b781e553590a4d1a9a9d79b3da52868ec6e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8be04aab858e310bc62a33e8f4521fddf202ee7620440713fe4ecc8ea9cd211b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0c65881b0d53b950376abb53f85823620ab764199169affa82db0e377a68afa"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", "--all-features", *std_cargo_args(path: "crates/lune")
  end

  test do
    (testpath/"test.lua").write("print(2 + 2)")
    assert_equal "4", shell_output("#{bin}/lune run test.lua").chomp
  end
end

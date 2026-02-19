class Odiff < Formula
  desc "Very fast SIMD-first image comparison library (with nodejs API)"
  homepage "https://github.com/dmtrKovalenko/odiff"
  url "https://github.com/dmtrKovalenko/odiff/archive/refs/tags/v4.3.2.tar.gz"
  sha256 "da32d852e2145ded6b485398ad31101e9435ed9255b3cbe15c7735374f2b9e6f"
  license "MIT"
  head "https://github.com/dmtrKovalenko/odiff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9cb3a56bedb3dc706bc0d20f327ba133c475ede848805efc7c4b8bc05a731cdc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dbb36e944ff54729f001085511a4f4edd7ad6a858ffedc645772a2773d69dbec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "586edf0e6ac966d1cadedd4c8a74690993182a8fd8bdaef437647cb0fd8d809f"
    sha256 cellar: :any_skip_relocation, sonoma:        "bfc842ad179c8d34d187a2954462d4982a3abec7ae3dccdf1f66218f1e6c9f00"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51037d5e22cc924480d398040e5f22301ba0cfcd0e2ac942daa1b805d4389443"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "225b4d5d1c7fd31f9db28de5e7e32bbd968548cead0a06932c3a2f3e6e86d236"
  end

  depends_on "zig" => :build

  on_intel do
    depends_on "nasm" => :build
  end

  def install
    system "zig", "build", *std_zig_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/odiff --version 2>&1")

    assert_match "Images are identical",
      shell_output("#{bin}/odiff #{test_fixtures("test.png")} #{test_fixtures("test.png")} 2>&1")
  end
end

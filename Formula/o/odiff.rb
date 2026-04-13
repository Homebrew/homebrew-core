class Odiff < Formula
  desc "Very fast SIMD-first image comparison library (with nodejs API)"
  homepage "https://github.com/dmtrKovalenko/odiff"
  url "https://github.com/dmtrKovalenko/odiff/archive/refs/tags/v4.3.3.tar.gz"
  sha256 "50c8edb6da90461f218c59ab85e6be21b6a5ad4a9e90f65e91b04134bf30dc47"
  license "MIT"
  head "https://github.com/dmtrKovalenko/odiff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e6fcd894a6ca26f53e76190e85d33e59fe520eec0a4fc79878254363563de0e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab46ea7de52f4d5623b7f422fb428a37f1fc7b7013dc3006008b7b875dd62ec1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "36e7d955a6fb0599ca8c0776ee31cdfac2f680ffe74bf2156d0bc12592abfaae"
    sha256 cellar: :any_skip_relocation, sonoma:        "edfe06c808e823f3ff070f6ce56d065e4e6f7776af5b928df455365b1e2ddf4a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6c4176f26859f1d52e83b85926823b34032367abb55cd7411f4e7ae4499f0769"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3530785e49488b5a08dcbe1ce5ff6d058c84711db92d9d78242b06fc6af3aaac"
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

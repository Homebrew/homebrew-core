class Havn < Formula
  desc "Fast configurable port scanner with reasonable defaults"
  homepage "https://github.com/mrjackwills/havn"
  url "https://github.com/mrjackwills/havn/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "ab6a1fb74a5670ddba4a48f8f02a4c0f36d0d33fbc20010f5534b56c05868352"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "261a3a4210b19e92ca7fc034d48ae75352581debf7a37b04db7e6d14872c53b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d211b60eb82c5747f1d78b9873ff30891f396bb7c870d777a5687d9c709e6a77"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91f7eb808fd4b8a43a4119b2c8840fc679f7adf158618ff57c8268b7318ad7e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "815cdcf947c0f940b08c2058f7088486a21c31279825dca7ee09959c980f3ee4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "080ba1a6b7b2eb2c9b35b032225769338ac1041cac9f08becd320765f6e6ebc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1f571e73a38d2cc3cbdcdf230f3d8189996299816cbb91131c72f88ae2add22"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/havn example.com -p 443 -r 6")
    assert_match "1 open\e[0m, \e[31m0 closed", output

    assert_match version.to_s, shell_output("#{bin}/havn --version")
  end
end

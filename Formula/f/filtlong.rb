class Filtlong < Formula
  desc "Quality filtering of long noisy DNA sequencing reads"
  homepage "https://github.com/rrwick/Filtlong"
  url "https://github.com/rrwick/Filtlong/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "09b43a0c9e2c6b40cd29e3025de8ff39302c0b5eabbf660a47c9c26bdf9dd35e"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d967c6236ad5842685f8544adbc7ef6453daa89ec80878b6f246b41c481f2e45"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9159034511e6b82c8bf41baf7b975bfea55a2f2ccc33526753f444bf6f42063"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5afa5a2204ffe2450f467a598720d96c6c484f6bd538e762f0b670db227ea62e"
    sha256 cellar: :any_skip_relocation, sonoma:        "32e497ffe6cca78134b859c3c3c315a2a07292ed4ac2331c9d4557decb0a1854"
    sha256 cellar: :any,                 arm64_linux:   "2ebebc6f44a27b16b2cf4a242165351261d99c7180bfabae36896d8f866e73d8"
    sha256 cellar: :any,                 x86_64_linux:  "be34ca8f4265931c437c47b6a6c7ee0334435aa08cbd381e441ab3f458b8ff20"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "make"
    bin.install "bin/filtlong"
    pkgshare.install "test"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/filtlong --version 2>&1")
    system bin/"filtlong", "--min_length", "1000", pkgshare/"test/test_trim.fastq"
  end
end

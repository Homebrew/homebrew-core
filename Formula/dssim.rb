class Dssim < Formula
  desc "RGBA Structural Similarity Rust implementation"
  homepage "https://github.com/kornelski/dssim"
  url "https://github.com/kornelski/dssim/archive/3.2.0.tar.gz"
  sha256 "b671aec5b117adb6f9c636ef70ecafbd671caacf8b110098565c01bf5171118f"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68ea1d7e64e07cbe5ffdcc22a38ac57d5552a32c79c52564f5e448dc9cc6b8aa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "967ad98b4e362da00167cad1d9091a1e3c74025f31fd373cd0be113066fdb6ef"
    sha256 cellar: :any_skip_relocation, monterey:       "bd24773eadbe47ca46c88e1afc73d1159eb29b165d315306e713bc2861dbae32"
    sha256 cellar: :any_skip_relocation, big_sur:        "2954d9685913deaedaf0e377952c884744c70067ae59d4ded16b787c499a475d"
    sha256 cellar: :any_skip_relocation, catalina:       "7bb8eab77f3ee40640a4a324ce8e3d20b56af1bab91710b14ceaad8182fe9837"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81d4e2afdf0ac2eca9a9fff75d309c658d66b705155e0b951920d1d56b9f7e58"
  end

  depends_on "nasm" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/dssim", test_fixtures("test.png"), test_fixtures("test.png")
  end
end

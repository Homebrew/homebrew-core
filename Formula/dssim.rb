class Dssim < Formula
  desc "RGBA Structural Similarity Rust implementation"
  homepage "https://github.com/kornelski/dssim"
  url "https://github.com/kornelski/dssim/archive/3.0.0.tar.gz"
  sha256 "ad2498d4b73d3e5210491750b82cdee833ec25ddab38f76a6dc46b21e0e572fa"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:     "b92c04687905f6d436e15e34705106a969c931c49416c0be5fada4676f68c2de"
    sha256 cellar: :any_skip_relocation, catalina:    "a45bab9dbd7de721418a18394c0b70dc66fcd44050c14a04b87e97687aa316a1"
    sha256 cellar: :any_skip_relocation, mojave:      "2c7b025773e8f419bd0edab3815e243708b47f60ad62fa4595fa5726c1ab77d0"
    sha256 cellar: :any_skip_relocation, high_sierra: "288735020c3dca238550306be4e1ca80636539c2b779211889f9f485e7b8b610"
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

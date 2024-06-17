class Bup < Formula
  desc "Backup tool"
  homepage "https://bup.github.io/"
  url "https://github.com/bup/bup/archive/refs/tags/0.33.3.tar.gz"
  sha256 "0aa6e98352c939180e82bbb0a647afd8d1b3d5eda6771b65e694099f6b956ac5"
  license all_of: ["BSD-2-Clause", "LGPL-2.0-only"]
  head "https://github.com/bup/bup.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fa4f5c208efca04606934745fe35d2776b479f6035fa9841eca924d5e900ecb2"
    sha256 cellar: :any,                 arm64_ventura:  "12d0542f3f0f72d356d58de92c9afa701ff0006ae233bf7ae6c11085ce70552a"
    sha256 cellar: :any,                 arm64_monterey: "9a6c3234293a20c544e7b1ea1f79ef68f63b0bf164def7165d946511cf6f67e6"
    sha256 cellar: :any,                 sonoma:         "be8a5f5f68a9d9d69c8fb473dc662953974ee9d1fa1aa454bd009502347ead4b"
    sha256 cellar: :any,                 ventura:        "68679c2a19db87c9b9e9334dd9903ecb75156d4372cfe16300444d8accbcf992"
    sha256 cellar: :any,                 monterey:       "984f9e6c5bdff86478d40bc0edc91332d606710430e5ca49005411b2a949f9b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a37bc1c9cd680141e67a6e73b31490256b6722d567f67afe1e84e556d36cfa06"
  end

  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12"

  def python3
    which("python3.12")
  end

  def install
    ENV["BUP_PYTHON_CONFIG"] = "#{python3}-config"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"bup", "init"
    assert_predicate testpath/".bup", :exist?
  end
end

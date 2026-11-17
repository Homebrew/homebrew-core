class Bup < Formula
  desc "Backup tool"
  homepage "https://bup.github.io/"
  url "https://github.com/bup/bup/archive/refs/tags/0.34.1.tar.gz"
  sha256 "3ffe5c8bf9da8c291972939959517f98b41f7c62476557bcc00ffa6b54752fe4"
  license all_of: ["BSD-2-Clause", "LGPL-2.0-only"]
  head "https://github.com/bup/bup.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "4a87f7bc6e4e75c3ce9df064d3791e4875cced9c30b62f7c5f5bc75bd41d4c1c"
    sha256 cellar: :any, arm64_tahoe:       "f2b2f1036206e362c8808d8ea8e1239f88b68d81996d99262cf1e57e4c5e0e53"
    sha256 cellar: :any, arm64_sequoia:     "540ec5a5987727050a77a879c39f86962eb5a8c9dc051aa88a3ce777a04f4453"
    sha256 cellar: :any, arm64_linux:       "60f8609e0b7917cd07c16ce3ad402b217fc32e43b03c8bc85b5190798ac30ffe"
    sha256 cellar: :any, x86_64_linux:      "e66fefeb5b569814ddc22f2408c15963020a5dc550786eedb740833345900f54"
  end

  depends_on "pandoc" => :build
  depends_on "pkgconf" => :build

  depends_on "python@3.15"
  depends_on "readline"

  on_macos do
    depends_on "bash" => :build # config_cflags[@]: unbound variable
    depends_on "make" => :build # Depends on `make` >= 4.2
  end

  on_linux do
    depends_on "acl"
  end

  def install
    ENV["BUP_PYTHON_CONFIG"] = "#{python3}-config"

    # Call `make` as `gmake` to use Homebrew `make`.
    system "gmake", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"bup", "init"
    assert_path_exists testpath/".bup"
  end
end

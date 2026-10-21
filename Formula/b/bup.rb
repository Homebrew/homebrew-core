class Bup < Formula
  desc "Backup tool"
  homepage "https://bup.github.io/"
  url "https://github.com/bup/bup/archive/refs/tags/0.34.tar.gz"
  sha256 "ab790f39e53bee9570f17c58d22e4bc03246f25d45e12cc1b7b5f2bef6d14611"
  license all_of: ["BSD-2-Clause", "LGPL-2.0-only"]
  head "https://github.com/bup/bup.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "e987baaf7f3fce9a5e47c0d16e993941a77abdbe56263901a64d3523bb89173a"
    sha256 cellar: :any, arm64_tahoe:       "d8932f1a917884f1ec9cbd44ab7e71d7219e643c4ed4321abb5dff216c3a8ea0"
    sha256 cellar: :any, arm64_sequoia:     "7dd0f645cab0a9bfdec64a4ae40fdbf1f489f077f7102288a78e0bd971ce19f4"
    sha256 cellar: :any, arm64_linux:       "8e8d1c2edd5e882081a382892ac543fc84767c6d40377e06bd062e5af9f7434e"
    sha256 cellar: :any, x86_64_linux:      "d4daea3296f0401a9635261e36202a469bde504a6ef516ba3c36f2dff76da351"
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

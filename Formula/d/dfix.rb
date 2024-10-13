class Dfix < Formula
  desc "Auto-upgrade tool for D source code"
  homepage "https://github.com/dlang-community/dfix"
  url "https://github.com/dlang-community/dfix.git",
      tag:      "v0.3.5",
      revision: "5265a8db4b0fdc54a3d0837a7ddf520ee94579c4"
  license "BSL-1.0"
  head "https://github.com/dlang-community/dfix.git", branch: "master"

  livecheck do
    url "https://code.dlang.org/packages/dfix"
    regex(%r{"badge">v?(\d+(?:\.\d+)+)</strong>}i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "39da39a95bfc89e9f3d9217f84f82aa0a1a076cb261c87b08b2eafd5eac9d96a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a2fe72edff2989cfb703c38117af11d7c8a08c988d02e1f65fe40e5a865bc819"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "99a3cf3405691368a721abb51a8538de16d46c2e24d4d3ce997ad7ebdbcbd847"
    sha256 cellar: :any_skip_relocation, monterey:       "39a9604c7256c671d71207c3dc89e15b44d411fe670a02c3a645199365365296"
    sha256 cellar: :any_skip_relocation, big_sur:        "56e0746a3726473359566042fb319f2cfa9f7603a258a6fe8c6277e92e4e1017"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc5f77825702b1aada0824cb46ea1b8575d9b101c4a7aec7e49381bef1f7f045"
  end

  # https://github.com/dlang-community/dfix/issues/60
  disable! date: "2024-02-22", because: :unmaintained

  on_arm do
    depends_on "ldc" => :build
  end

  on_intel do
    depends_on "dmd" => :build
  end

  def install
    ENV["DMD"] = if Hardware::CPU.arm?
      "ldmd2"
    elsif OS.linux?
      "dmd -fPIC"
    end
    system "make"
    bin.install "bin/dfix"
    pkgshare.install "test/testfile_expected.d", "test/testfile_master.d"
  end

  test do
    system bin/"dfix", "--help"

    cp "#{pkgshare}/testfile_master.d", "testfile.d"
    system bin/"dfix", "testfile.d"
    system "diff", "testfile.d", "#{pkgshare}/testfile_expected.d"
    # Make sure that running dfix on the output of dfix changes nothing.
    system bin/"dfix", "testfile.d"
    system "diff", "testfile.d", "#{pkgshare}/testfile_expected.d"
  end
end

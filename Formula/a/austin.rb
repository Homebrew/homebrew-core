class Austin < Formula
  desc "Python frame stack sampler for CPython"
  homepage "https://github.com/P403n1x87/austin"
  url "https://github.com/P403n1x87/austin/archive/v3.6.0.tar.gz"
  sha256 "c29bcd84ff0060efbb282c3f36666de9049dcdb4ae57e26a844d8f4219f3b6f4"
  license "GPL-3.0-or-later"
  head "https://github.com/P403n1x87/austin.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "90c711e04cdaa07e84e9c171dfa2a0726ba65b9d35823afbaaaff3e82302c56f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "25e17337744671b82d76d5945f7509609438fe5960032dc79253ded8abfcff75"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e71cac7c434c0a77d2076de01a3d0d942c4b1a70af21e44dc32b375e9df5aaf4"
    sha256 cellar: :any_skip_relocation, sonoma:         "6f1b3411a7ae8e977acc9fe299fa4f27b04feafcf0bd2c04e128c10928d69ec7"
    sha256 cellar: :any_skip_relocation, ventura:        "42d5a8b61c806b1b093767c02589358f7e16b6ee81264345006b1055f00fc9f8"
    sha256 cellar: :any_skip_relocation, monterey:       "1113604e46f3d270d4d87ef5d1e20b945d824c341f03a1c251c10577a94fd679"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5261862f6e454451f829c908c7320125d170c5a4619dbe66ffbdadbf82b379a"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "python@3.12" => :test

  def install
    system "autoreconf", "--install"
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "install"
    man1.install "src/austin.1"
  end

  test do
    if OS.mac?
      assert_match "Insufficient permissions. Austin requires the use of sudo",
        shell_output(bin/"austin --gc 2>&1", 37)
    else
      assert_match "need either a command to run or a PID to attach to",
        shell_output(bin/"austin --gc 2>&1", 255)
    end
    assert_equal "austin #{version}", shell_output(bin/"austin --version").chomp
  end
end

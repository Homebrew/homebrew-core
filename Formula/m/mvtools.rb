class Mvtools < Formula
  desc "Filters for motion estimation and compensation"
  homepage "https://github.com/dubhater/vapoursynth-mvtools"
  url "https://github.com/dubhater/vapoursynth-mvtools/archive/refs/tags/v24.tar.gz"
  sha256 "ccff47f4ea25aa13b13fabd5cf38dd0be1ceda10d9ad6b52bd42ecf9d6eb24ad"
  license "GPL-2.0-or-later"
  head "https://github.com/dubhater/vapoursynth-mvtools.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "3c0e17fdf774da0b5e0d8ae822a9401523ded7288cd98bcab79c5bb074867d95"
    sha256 cellar: :any,                 arm64_sequoia:  "f3e493940d6f162c23cb1ffbd90f6592c4d8fb163810ea717a7b57d9a4152bfa"
    sha256 cellar: :any,                 arm64_sonoma:   "92edb441ffb705b90a8fe0fd12fa1fb27896b5edfb2df3427ebdcd7b496f182c"
    sha256 cellar: :any,                 arm64_ventura:  "0b437191d2e0b8880f53e2f7650028085c5bc48e0c73eb9cd9c7bd1eddd92e19"
    sha256 cellar: :any,                 arm64_monterey: "8381da2f99f7ebc1cf687c3eb690375da292e3cece482bf063017b669d920c8c"
    sha256 cellar: :any,                 sonoma:         "a6e2de4fb621cceec1a74362de32d27f2353ef18152d6401c170cf7f718470a0"
    sha256 cellar: :any,                 ventura:        "bcd432707884f5ceea9ff50e5280da4c9c6c4dfc1c3c6981ad70d921427dc2dd"
    sha256 cellar: :any,                 monterey:       "d38fc8a9a06f508949d8643396024d630aac374d8ed3e792a23cdea10bb21c48"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "ae5a71a3625699b8ea9751865c61a537dba02dd5cd729bbac006761054112746"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1e2a5e84ec6842466bca0a44a572a45c491e7fd3c30ea5e4125f02d664f04fa"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "nasm" => :build
  depends_on "pkgconf" => :build

  depends_on "fftw"
  depends_on "vapoursynth"

  def install
    system "./autogen.sh"
    system "./configure", *std_configure_args
    system "make", "install"
  end

  def caveats
    <<~EOS
      MVTools will not be autoloaded in your VapourSynth scripts. To use it
      use the following code in your scripts:

        vs.core.std.LoadPlugin(path="#{HOMEBREW_PREFIX}/lib/#{shared_library("libmvtools")}")
    EOS
  end

  test do
    script = <<~PYTHON.split("\n").join(";")
      import vapoursynth as vs
      vs.core.std.LoadPlugin(path="#{lib/shared_library("libmvtools")}")
    PYTHON
    python = Formula["vapoursynth"].deps
                                   .find { |d| d.name.match?(/^python@\d\.\d+$/) }
                                   .to_formula
                                   .opt_libexec/"bin/python"
    system python, "-c", script
  end
end

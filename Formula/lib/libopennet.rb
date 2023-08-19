class Libopennet < Formula
  desc "Provides open_net() (similar to open())"
  homepage "https://www.rkeene.org/oss/libopennet"
  url "https://www.rkeene.org/files/oss/libopennet/libopennet-0.9.9.tar.gz"
  sha256 "d1350abe17ac507ffb50d360c5bf8290e97c6843f569a1d740f9c1d369200096"
  license "LGPL-2.1"

  livecheck do
    url :homepage
    regex(/href=.*?libopennet[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1ce4bb615aaa4579a6719a21eaaea4cdcf6beba142a9191e9aca597d6fbdf726"
    sha256 cellar: :any,                 arm64_monterey: "7adee83fdb8fc7a65bd7a4f34b2cedfe58a2ef51e66892fd9ecd89732c1b779c"
    sha256 cellar: :any,                 arm64_big_sur:  "6c773cf155f2d32421b30368262329bb8d943c8c9f34b095fc1387682bb11386"
    sha256 cellar: :any,                 ventura:        "789a576fa0b7cfcaf5fb155d4b65ae8afd4c8d7835c36bfedbaaebb33434c7d7"
    sha256 cellar: :any,                 monterey:       "d14a15468f38a3c053272c0669e1db3a550bd121ddb6dbbf8a47637de6fc956c"
    sha256 cellar: :any,                 big_sur:        "1c514ff48871809fd77cadcded9c2dc71f7913fde66c81fe3a9c6488b927d17f"
    sha256 cellar: :any,                 catalina:       "0f9b40e9c906fce8df8abc866680bf6fbe60cadc5af24dac309e1d51a0f5e99d"
    sha256 cellar: :any,                 mojave:         "4702cca034bb0b60b4555615664cc4aedee95c189f37e23e93013594f1dc9321"
    sha256 cellar: :any,                 high_sierra:    "82232ab7a71481570e3119e119bc93ef29a9d553c11e16fb93f157c66a7dfe8a"
    sha256 cellar: :any,                 sierra:         "c3447365aeb1a478b14b5a71b6ffd29a1f95754fb460ed6f618b55e2f958c227"
    sha256 cellar: :any,                 el_capitan:     "de1cb9622ec3b6501236af7e66367bc5bbaa20dfb8e3ae328a339bea6d708bab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d12f92e4c1e648507685be0a40102bbf253da35bc2bf2bc25b412e8900165a6d"
  end

  on_arm do
    # Added automake as a build dependency to update config files for ARM support.
    depends_on "automake" => :build
  end

  def install
    if Hardware::CPU.arm?
      # Workaround for ancient config files not recognizing aarch64 macos.
      %w[config.guess config.sub].each do |fn|
        cp Formula["automake"].share/"automake-#{Formula["automake"].version.major_minor}"/fn, fn
      end
    end
    # Fix flat namespace usage.
    inreplace "configure", "-flat_namespace -undefined suppress", "-undefined dynamic_lookup"

    system "./configure", *std_configure_args, "--mandir=#{man}"
    system "make"
    system "make", "install"
  end
end

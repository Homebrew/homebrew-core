class Libopennet < Formula
  desc "Provides open_net() (similar to open())"
  homepage "https://www.rkeene.org/oss/libopennet"
  url "https://www.rkeene.org/files/oss/libopennet/libopennet-0.9.9.tar.gz"
  sha256 "d1350abe17ac507ffb50d360c5bf8290e97c6843f569a1d740f9c1d369200096"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  livecheck do
    url :homepage
    regex(/href=.*?libopennet[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "543c5813be3a290d4f05c97abf94665d07cbc7cee5eb84c5c3c5b1689be5884d"
    sha256 cellar: :any,                 arm64_sequoia:  "e5e9c1ebe5ba34938705b7b0b1f70569348096a58d96b2a7327526f5d3aeb5f7"
    sha256 cellar: :any,                 arm64_sonoma:   "cb4414cd607a9de6b0cf79edc026805665037051c6cb17b289cd5a5e5ecda5a1"
    sha256 cellar: :any,                 arm64_ventura:  "1ce4bb615aaa4579a6719a21eaaea4cdcf6beba142a9191e9aca597d6fbdf726"
    sha256 cellar: :any,                 arm64_monterey: "7adee83fdb8fc7a65bd7a4f34b2cedfe58a2ef51e66892fd9ecd89732c1b779c"
    sha256 cellar: :any,                 arm64_big_sur:  "6c773cf155f2d32421b30368262329bb8d943c8c9f34b095fc1387682bb11386"
    sha256 cellar: :any,                 sonoma:         "404801ea9f6feb9da41e23a40459c16edf74dcc8a03e5274f009821b622e8a6b"
    sha256 cellar: :any,                 ventura:        "789a576fa0b7cfcaf5fb155d4b65ae8afd4c8d7835c36bfedbaaebb33434c7d7"
    sha256 cellar: :any,                 monterey:       "d14a15468f38a3c053272c0669e1db3a550bd121ddb6dbbf8a47637de6fc956c"
    sha256 cellar: :any,                 big_sur:        "1c514ff48871809fd77cadcded9c2dc71f7913fde66c81fe3a9c6488b927d17f"
    sha256 cellar: :any,                 catalina:       "0f9b40e9c906fce8df8abc866680bf6fbe60cadc5af24dac309e1d51a0f5e99d"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "dd3619a3083c2078621061fde39ac45d20825f6312cd177828289861d70b63d6"
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

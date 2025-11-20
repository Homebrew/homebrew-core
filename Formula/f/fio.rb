class Fio < Formula
  desc "I/O benchmark and stress test"
  homepage "https://github.com/axboe/fio"
  url "https://github.com/axboe/fio/archive/refs/tags/fio-3.41.tar.gz"
  sha256 "38f2c723eda1d94fd25c91dbad30da7a551a58840b7a6368eaee3daa700fb088"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^fio[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b9478d8c99b007a7ce662a90c6cf07f2e047406bc29b64a3eeb840325f918ecd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "328d27e82b942ff7e50a13d2492c5bdfe0522a9e0001cfa7b765410a427fcc0e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a38a0c4bb6decf2952e8ad1ba59c8e64dc86d484019c598c6dbd072d8b98c8b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8868622bae51c1d4cda01b9d5ff70989dbde636f677902adc8d7a8e94bc336cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "78e1d57c429fef2c6aaa5e74a742b58419c5d930cb6a369e0c4eb7db02c827ac"
    sha256 cellar: :any_skip_relocation, ventura:       "5d5f62218f93f767d67f2e3ce252cf242d62169204adc2245805b27e686f3a8d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e21d0ff146a17aae8ce2fbc1193b068ee7829329d4d8672221f5ab3a36311e96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7e56e62de3864f477e8926fbcaef5ebe534ec4191e184f1b20e1f853bfd0f63"
  end

  uses_from_macos "zlib"

  conflicts_with "fiona", because: "both install `fio` binaries"

  def install
    ENV.runtime_cpu_detection
    system "./configure"
    # fio's CFLAGS passes vital stuff around, and crushing it will break the build
    system "make", "prefix=#{prefix}",
                   "mandir=#{man}",
                   "sharedir=#{share}",
                   "CC=#{ENV.cc}",
                   "V=true", # get normal verbose output from fio's makefile
                   "install"
  end

  test do
    system bin/"fio", "--parse-only"
  end
end

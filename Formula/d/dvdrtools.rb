class Dvdrtools < Formula
  desc "Fork of cdrtools DVD writer support"
  homepage "https://savannah.nongnu.org/projects/dvdrtools/"
  url "https://savannah.nongnu.org/download/dvdrtools/dvdrtools-0.2.1.tar.gz"
  sha256 "053d0f277f69b183f9c8e8c8b09b94d5bb4a1de6d9b122c0e6c00cc6593dfb46"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://download.savannah.gnu.org/releases/dvdrtools/"
    regex(/href=.*?dvdrtools[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "d9ce7dd044c0b813f15a0a53332e50bd2f4b85fca18f7bb9951796f061abdb24"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "57b79ee1791a3cbd816e11cbb178cf961f4fc0b5b71324233ea6c68a6c420db1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0b059fb5d92689dbdd1330d2a600a5255de0ce01f24e6e911e548a92494897ee"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d41b802f7e601c727aab83ab6fa63b70303c717fa4709059c4b653b599b5f248"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "587872ae7f087b62cf2b227faeb303bffdc9365794bf60daf8f071c2039869f1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7b93d029d54fa99b94010b18776bdf36c889e81e8f169f8745f319b7b7b6f9f0"
    sha256 cellar: :any_skip_relocation, sonoma:         "de8feee693d3923d18cc2e532afd15cb99b0886abfd790e948f67da4e88d612f"
    sha256 cellar: :any_skip_relocation, ventura:        "bcc5fd8f00fad05c8027a1f151a39da5cf3e3a57ed84c8753834202ffd903797"
    sha256 cellar: :any_skip_relocation, monterey:       "63a9ae5cc3cf6c54d7d7302dab688c4cd560ce69d30eceaf0de09d7f5da53d7b"
    sha256 cellar: :any_skip_relocation, big_sur:        "c969433ed859dab8f0551c6eab562a4cc272b063f333e0208081ea3b5940c76b"
    sha256 cellar: :any_skip_relocation, catalina:       "40f565db4f098c70bed700dc88edd45951e58a7f7c64583d52db81afcdbde704"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "8049f79b1ed1c0d2a581343623b60d621797365f0fdfec5f5b5e12ba1ea37650"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0ded8f875ea08da1c4ac07675a925b475414f03e03071b6e4445ec690494d88"
  end

  conflicts_with "cdrtools",
    because: "both cdrtools and dvdrtools install binaries by the same name"

  # Below three patches via MacPorts.
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/dvdrtools/patch-cdda2wav-cdda2wav.c"
    sha256 "f792a26af38f63ee1220455da8dba2afc31296136a97c11476d8e3abe94a4a94"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/dvdrtools/patch-cdrecord-cdrecord.c"
    sha256 "c7f182ce154785e19235f30d22d3cf56e60f6c9c8cc953a9d16b58205e29a039"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/dvdrtools/patch-scsi-mac-iokit.c"
    sha256 "f31253e021a70cc49e026eed81c5a49166a59cb8da1a7f0695fa2f26c7a3d98f"
  end

  def install
    # Fix compile with newer Clang
    if DevelopmentTools.clang_build_version >= 1403
      ENV.append_to_cflags "-Wno-implicit-function-declaration -Wno-int-conversion"
    end

    ENV["LIBS"] = "-framework IOKit -framework CoreFoundation" if OS.mac?

    args = ["--mandir=#{man}"]
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end
end

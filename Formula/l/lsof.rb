class Lsof < Formula
  desc "Utility to list open files"
  homepage "https://github.com/lsof-org/lsof"
  url "https://github.com/lsof-org/lsof/archive/refs/tags/4.99.5.tar.gz"
  sha256 "3c591556c665196e0aada5982ff43c75e248187bad78bb1368d8fb9c1c527e6e"
  license "lsof"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "00f765358cfc137b0e6f1cea785ca0adc2503d1c098fe490633cd40454eab652"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ee0274d10c70990a175776c2e81e4994e7e250a507f68c4629134e84841d00a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e16498ba8a8a06aa57619b9dbefec05da361f04d937c103f0ddf906685674fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2ece295b0bd6dcf63cd66d840220ff1c3e8de7d0ac26cf811cc8e698442751ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "02cffb2a55c80400aebdcc6ec0655b8dcd8392abfa91d128c71ddeae7246a0a6"
    sha256 cellar: :any_skip_relocation, ventura:       "a57568893d1f9abf6cd8c0b119f7a838d6833786061fcc6c778b48bdca858cdb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "863b7d80d93ba238f4a77f7f566b1a9171ec8c00407420ddde092cde94f93e49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d076f7bc43d2e3dcc899fc979f08873f562ccff1fdad1ceaad9da3a982a14ee"
  end

  keg_only :provided_by_macos

  on_linux do
    depends_on "libtirpc"
  end

  def install
    if OS.mac?
      ENV["LSOF_INCLUDE"] = MacOS.sdk_path/"usr/include"

      # Source hardcodes full header paths at /usr/include
      inreplace "lib/dialects/darwin/machine.h", "/usr/include", MacOS.sdk_path/"usr/include"
    else
      ENV["LSOF_INCLUDE"] = HOMEBREW_PREFIX/"include"
    end

    ENV["LSOF_CC"] = ENV.cc
    ENV["LSOF_CCV"] = ENV.cxx

    mv "00README", "README"
    system "./Configure", "-n", OS.kernel_name.downcase

    system "make"
    bin.install "lsof"
    man8.install "Lsof.8"
  end

  test do
    (testpath/"test").open("w") do
      system bin/"lsof", testpath/"test"
    end
  end
end

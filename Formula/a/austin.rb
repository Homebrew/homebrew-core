class Austin < Formula
  desc "Python frame stack sampler for CPython"
  homepage "https://github.com/P403n1x87/austin"
  url "https://github.com/P403n1x87/austin/archive/refs/tags/v4.1.0.tar.gz"
  sha256 "93fa2a3d86ef1199b4ac027e8874d6a960bd1cec2cdc3239c286dc85e74cb158"
  license "GPL-3.0-or-later"
  head "https://github.com/P403n1x87/austin.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "763a64952097fb53780d9b7daec7e389623d65cb7800217436cd4afe97357f25"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f180633908671f28c4d68a7a50892f6325ea7a37b33680b671d62ca127c83dca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5b5e13e3db248c5f918b5504626139f7ff5eb73897e77365b54cfec0dc340aee"
    sha256 cellar: :any,                 arm64_linux:       "240cdd46555c72ec9d4ca3c24ee7c092dd6684c96e63b1844ca089cdf5975a75"
    sha256 cellar: :any,                 x86_64_linux:      "3b0ec667ba56f3593ef5bd32436fd358accd66db63bf3d5fd8bf7c212b08ea0f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  uses_from_macos "python" => :test

  deny_network_access!

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "install"
    man1.install "src/austin.1"
  end

  test do
    command = "#{bin}/austin -o samples.mojo -i 1ms python3 -c 'from time import sleep; sleep(1)' 2>&1"
    if OS.mac?
      assert_match "Insufficient permissions. Austin requires the use of sudo", shell_output(command, 2)
    else
      assert_match "Sampling Statistics", shell_output(command)
    end
    assert_equal "austin #{version}", shell_output("#{bin}/austin --version").chomp
  end
end

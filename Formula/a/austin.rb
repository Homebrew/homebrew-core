class Austin < Formula
  desc "Python frame stack sampler for CPython"
  homepage "https://github.com/P403n1x87/austin"
  url "https://github.com/P403n1x87/austin/archive/refs/tags/v4.0.0.tar.gz"
  sha256 "1a857d4590092cd8f7fc110cd83c31311dde03113a5dc4cb93c4eb31e5c8f884"
  license "GPL-3.0-or-later"
  head "https://github.com/P403n1x87/austin.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "da1ec3babb470a9b8e4f12b70ece43a4d0d00b5de8663477bfb88d5a10544b14"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d44ca3dd16c310c1aa9b06039ce4a3e660e9f6599d8f21ddfcc1ef0f0d93a3b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2bb32d8e6f61cbb427fa68b9ba33e3028581dff7cba144686522f3fae9f6a429"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff93fdbf6c416993ffc4e25f03c56ccc9a832d8d06fb6bda5a4142ff41083b0f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "29c1aee7c3027fa88156dfbe09656e9a577f0c38f145ce3b40fe1daafc93a474"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8881075b254897ac5c175df033cf18c4e3c9be2c8f7da9c089ff51f829121833"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  uses_from_macos "python" => :test

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

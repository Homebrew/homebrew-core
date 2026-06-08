class F3 < Formula
  desc "Test various flash cards"
  homepage "https://fight-flash-fraud.readthedocs.io/en/latest/"
  url "https://github.com/AltraMayor/f3/archive/refs/tags/v10.0.tar.gz"
  sha256 "ce54275b7793f97391583ede33c1d87590901d8da20cce604b1f07a029aefc67"
  license "GPL-3.0-only"
  head "https://github.com/AltraMayor/f3.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2a1fa8a2cbf80773e1709d368f4a2f245af846d30bb0b974d3bd4f491b9bc07c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aadb9f85ba049cc4c33b3b6cbc8d11d075ef9d0f0c4e029d1344fb9f3c5609ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ab3f249a7a4ec1e534f299595b305a54171a40d38ff2480b23447c17abd1647"
    sha256 cellar: :any_skip_relocation, sonoma:        "e6405ef2a75819cb1cf8833bd720a427f701dcf1c0efe9b5f2de36ac8f9a1daf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a712312a15838a0c835f4602c7fc82217361fe660b5ff173eb7de202b92a89e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6dfd032994b66f14f2df374fdd7eac61c68302e9359517de1e3423ed7f52a3c1"
  end

  on_macos do
    depends_on "argp-standalone"
  end

  def install
    args = []
    args << "ARGP=#{Formula["argp-standalone"].opt_prefix}" if OS.mac?
    system "make", "all", *args
    bin.install %w[build/f3read build/f3write]
    man1.install "man/f3read.1"
    man1.install_symlink "f3read.1" => "f3write.1"
  end

  test do
    system bin/"f3read", testpath
  end
end

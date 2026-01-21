class Progress < Formula
  desc "Coreutils progress viewer"
  homepage "https://github.com/Xfennec/progress"
  url "https://github.com/Xfennec/progress/archive/refs/tags/v0.17.tar.gz"
  sha256 "ee9538fce98895dcf0d108087d3ee2e13f5c08ed94c983f0218a7a3d153b725d"
  license "GPL-3.0-or-later"
  head "https://github.com/Xfennec/progress.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "8c2f2b8662edb63080b92379916d9a3baf7e79147bdcaac1e5ce734d883eb20a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "f661615f320a4ac93f492d247054c8e244b2a234f37b3a7d7852f2b4541ab927"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1d7b757f8bcc4961b40058126f0614470418e55ac6fead877cdd8e4f98684a32"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4102bb16c1bf18d9d0a46b8a170cef1f0b1032ec07f0835de750b2f998d03393"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "11cff7ffa2580585d9fab4f550d1229a59337dcddf07a1e7980b46b473bfd4b0"
    sha256 cellar: :any_skip_relocation, sonoma:         "69d736301d682b39561e659e6a7a37f886cf842dcced3dd7856c32947eee6995"
    sha256 cellar: :any_skip_relocation, ventura:        "c838dd67490a7aaf419ca5e538b699c895b42911d4c8998876258648b8eb06f2"
    sha256 cellar: :any_skip_relocation, monterey:       "b91471bcf961169742cca485c90b52dd6be8cfb0f9ef8b5169124309d2143f7b"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "ca13d94aa5c8ad7eb020650e96c0d120a72d1e9e8ef4c656febd2e6595b188bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86cdd8365a105b82a4ab6a8f041bdc8c1dc277ce12eb06626f32e484636b5a78"
  end

  depends_on "pkgconf" => :build
  uses_from_macos "ncurses"

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    pid = spawn "/bin/dd", "if=/dev/urandom", "of=foo", "bs=512", "count=1048576"
    sleep 1
    begin
      assert_match "dd", shell_output(bin/"progress")
    ensure
      Process.kill 9, pid
      Process.wait pid
      rm "foo"
    end
  end
end

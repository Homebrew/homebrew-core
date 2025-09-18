class Pipemeter < Formula
  desc "Shows speed of data moving from input to output"
  homepage "https://launchpad.net/pipemeter"
  url "https://launchpad.net/pipemeter/trunk/1.1.5/+download/pipemeter-1.1.5.tar.gz"
  sha256 "e470ac5f3e71b5eee1a925d7174a6fa8f0753f2107e067fbca3f383fab2e87d8"
  license "GPL-2.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "f87dfabadf8edc8e63b7032810808c7b126c8ade8712687113170ae531796760"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "0653426bc1f7a2f36bc886279953ec40660d867797f4623162cc749c2f48ba0e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "197626afa86a59a767aa171fc9c7244c0fecb1548175c59aee7af5a64051e7d0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8d3ac998da1225db393df052edb693c65caaca7f04e267f924b6936d284f0e03"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d46321ba4f29458d93dc2e04aebf6e6a935f64cbead1dfec03d2e44114a28f80"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1ca7da50232374280744805d8497a42c4e8795d4592a1e6ec35fb3e51812cea9"
    sha256 cellar: :any_skip_relocation, sonoma:         "c24ccbfa414a1fe38893a2d26a219bf09c278028a94dfe04befec9bed787e9b3"
    sha256 cellar: :any_skip_relocation, ventura:        "389145513b346cad14c8ae13c231816b9b679087464396182cdf047a04b93db9"
    sha256 cellar: :any_skip_relocation, monterey:       "55c1cfc32045a6ceeb62ce15159f5d5f43c807eb119eef4b32eb2359c37a7b59"
    sha256 cellar: :any_skip_relocation, big_sur:        "ef9f94223b9b5d583ca7f3714e85fbdc59721be6bdc31f46bda43cecb4a4c0b5"
    sha256 cellar: :any_skip_relocation, catalina:       "faf2fcb90aebb9e26bfd1f9dcfd32bb43fd4247a87a466640dcd74824806da00"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "128d3f2743369e05eab0274a428c4f64054def38c7bdd6636602c66cbf8289cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3bcb2fe10310749fb1afdee597abd956efefd6ad1b501440c322a7c876a7ad36"
  end

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"

    # Fix GNU `install -D` syntax issue
    inreplace "Makefile", "install -Dp -t $(DESTDIR)$(PREFIX)/bin pipemeter",
                          "install -p pipemeter $(PREFIX)/bin"
    inreplace "Makefile", "install -Dp -t $(DESTDIR)$(PREFIX)/man/man1 pipemeter.1",
                          "install -p pipemeter.1 $(PREFIX)/share/man/man1"

    bin.mkpath
    man1.mkpath
    system "make", "install"
  end

  test do
    assert_match "3.00B", pipe_output("#{bin}/pipemeter -r 2>&1 >/dev/null", "foo", 0)
  end
end

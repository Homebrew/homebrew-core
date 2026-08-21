class Oksh < Formula
  desc "Portable OpenBSD ksh, based on the public domain Korn shell (pdksh)"
  homepage "https://github.com/ibara/oksh"
  url "https://github.com/ibara/oksh/releases/download/oksh-7.9/oksh-7.9.tar.gz"
  sha256 "51b2d92515950c959dbf24f6fc33336db8c0526c2a50fee4ca598a18a6114a49"
  license all_of: [:public_domain, "BSD-3-Clause", "ISC"]
  head "https://github.com/ibara/oksh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "af1d2a4ba7461132c05d6d8b534d9ef1d2643df9076a2151fefb6c2e92fe49b2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8abfc1a1b116b56400e2d37dd93e342637f929c20897d31c4d89d44149581d8b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fdfb8a5c463f1f512a906aefd1e729517c5067e77bf2bf8722881ee9bbb49704"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3725ca77d7d70798b49d57abd5f84517bb088089b2b4a87296108dbdb5ce0b2"
    sha256 cellar: :any,                 arm64_linux:   "6f9e7349d5c097e849740fe47501085dfdbc4d336eeb74bf95106680d367f293"
    sha256 cellar: :any,                 x86_64_linux:  "e3b4d30eeb49d1011e53f86542141a2c3246715aa83344dcbbe8ed73e29e300c"
  end

  uses_from_macos "ncurses"

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "hello", shell_output("#{bin}/oksh -c \"echo -n hello\"")
  end
end

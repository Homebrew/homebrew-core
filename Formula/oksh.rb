class Oksh < Formula
  desc "Portable OpenBSD ksh, based on the public domain Korn shell (pdksh)"
  homepage "https://github.com/ibara/oksh"
  url "https://github.com/ibara/oksh/releases/download/oksh-6.9/oksh-6.9.tar.gz"
  sha256 "c08d97b2ac9ee5d88e9e508d27c75502b2d06c20d4c5ab87b496cb3b9951bd35"
  license all_of: [:public_domain, "BSD-3-Clause", "ISC"]
  head "https://github.com/ibara/oksh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a1cca252262fb01ab4de195acc65986a20644936659bf6ffe2538d37deb78281"
    sha256 cellar: :any_skip_relocation, big_sur:       "b5bae682becb5abddfb85bf08a48c0acb5f932f6720f11a2dc6a4ee6e1623cb0"
    sha256 cellar: :any_skip_relocation, catalina:      "9dc5b1d08b077320bc7a91855656bec8afb5d84dd0d4673a8c98455098ef8ee4"
    sha256 cellar: :any_skip_relocation, mojave:        "197f0a93fb2989dde3cda1b2013c5b03521630d1e00a55af6de08dee354c3078"
  end

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "hello", shell_output("#{bin}/oksh -c \"echo -n hello\"")
  end
end

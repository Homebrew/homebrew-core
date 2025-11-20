class Oksh < Formula
  desc "Portable OpenBSD ksh, based on the public domain Korn shell (pdksh)"
  homepage "https://github.com/ibara/oksh"
  url "https://github.com/ibara/oksh/releases/download/oksh-7.8/oksh-7.8.tar.gz"
  sha256 "3b30d5a1183b829590cc020d8ab87f22d288e98dc3fdf12feb7159536beaa950"
  license all_of: [:public_domain, "BSD-3-Clause", "ISC"]
  head "https://github.com/ibara/oksh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ada92d98bf5afc55fa57bd5a67656dda5694f6f45a1fbaa99c22b92a792f1579"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "efe4ab1f8b53d82cb1faf48bc2b0f3fedc8bd3ea3defb33ca51dee8d2afd0553"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "63a57d4c141205fae7176186dd0a4f9f74db9191a79e679e842cdf2f2b6528f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "d13fac5d94bf0f2cab0029848d4324a4e938d8efc3d2d22f89d13ee44388aabb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4cb56f25784348e87b2824c946f27e38403cdf1a956e1dd36add9b8305484807"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c873e983dc4fb309264a6da0b94725eee67beab552cff478cd114b26b6fde3e5"
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

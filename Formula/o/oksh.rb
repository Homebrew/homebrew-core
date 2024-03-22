class Oksh < Formula
  desc "Portable OpenBSD ksh, based on the public domain Korn shell (pdksh)"
  homepage "https://github.com/ibara/oksh"
  url "https://github.com/ibara/oksh/releases/download/oksh-7.4/oksh-7.4.tar.gz"
  sha256 "be9a8d457bf373bd04618074c41b46f4edec2ba1c57a58be881d60eaa6628596"
  license all_of: [:public_domain, "BSD-3-Clause", "ISC"]
  head "https://github.com/ibara/oksh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "82df15049ac624763f4b5efed80acd13a9265762c80721483fe84b8d6ae70dee"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d84f6843f8cb97faebe32f0bcbe05bb0388b7ffe1eb7e21e4998439dc0e8b8de"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e6a3ae56ba8a6626d7b563d7eaa55da473e3f3c401bda5d2416f568ef5e390a1"
    sha256 cellar: :any_skip_relocation, sonoma:         "0f050d1a1242aeaf7aa30ea56dc2ca8602c1121aa723b139d5cd87f339a5cb91"
    sha256 cellar: :any_skip_relocation, ventura:        "fa9aa852377044faeafdceb2fae9687651870b49ff06613a683fe1b1d463a954"
    sha256 cellar: :any_skip_relocation, monterey:       "a3be26ec8d532eb55008e668bfa17d50a25ab378b471a6e61e5fde0f92cafaa2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3374ff6619982a6f2ac1a40ba2e0fde737146083d0c0566d25a75000a70c7308"
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

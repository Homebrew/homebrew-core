class Pod2man < Formula
  desc "Perl documentation generator"
  homepage "https://www.eyrie.org/~eagle/software/podlators/"
  url "https://archives.eyrie.org/software/perl/podlators-v6.0.2.tar.xz"
  sha256 "22f5941c848756c05396356437dc799b32703f4fc282f0f281b9c83696500183"
  license any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"]

  livecheck do
    url "https://archives.eyrie.org/software/perl/"
    regex(/href=.*?podlators[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "29bf28b46917bfa959a3e04e2285491b9da82a78540341141c45cef662db5897"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "0937a01be86e0dd18adaca7675da973dfbfa8c9d5dbca3e0a2eacad020aa8ef7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b40bf5470087e943cc5a965f9788962d4dd44c831d08e95105a50bc5c325123c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c0a9a958c8614e6452f8e1d893f0a277011ca50b8160929b307139c911511b14"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c0a9a958c8614e6452f8e1d893f0a277011ca50b8160929b307139c911511b14"
    sha256 cellar: :any_skip_relocation, sonoma:         "c18bed6c302dfaa0c4373d546f99d0b1dbee75bc618fa2f914b54379e9a57bbd"
    sha256 cellar: :any_skip_relocation, ventura:        "c8b7d64bb1ed99ec0d43c980a0b559e40a0c23dec4651fd2098b8728f33e3c71"
    sha256 cellar: :any_skip_relocation, monterey:       "c8b7d64bb1ed99ec0d43c980a0b559e40a0c23dec4651fd2098b8728f33e3c71"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "36c74b6c69d5f917a362b69be53f2e269951278607071c65f700c39462ee422b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "269cdc0db938df147bab44127e86b05cf46074741bd9d8644b08f88a00e62f97"
  end

  keg_only "it conflicts with the pod2man that ships with Perl"

  resource "Pod::Simple" do
    url "https://cpan.metacpan.org/authors/id/K/KH/KHW/Pod-Simple-3.45.tar.gz"
    sha256 "8483bb95cd3e4307d66def092a3779f843af772482bfdc024e3e00d0c4db0cfa"
  end

  def install
    resource("Pod::Simple").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make"
      system "make", "install"
    end
    ENV.prepend_path "PERL5LIB", libexec/"lib/perl5"

    system "perl", "Makefile.PL", "INSTALL_BASE=#{prefix}",
                   "INSTALLSITEMAN1DIR=#{man1}", "INSTALLSITEMAN3DIR=#{man3}"
    system "make"
    system "make", "install"
    bin.env_script_all_files libexec/"bin", PERL5LIB: "#{lib}/perl5:#{libexec}/lib/perl5"
  end

  test do
    (testpath/"test.pod").write "=head2 Test heading\n"
    manpage = shell_output("#{bin}/pod2man #{testpath}/test.pod")
    assert_match '.SS "Test heading"', manpage
    assert_match "Pod::Man v#{version}", manpage
  end
end

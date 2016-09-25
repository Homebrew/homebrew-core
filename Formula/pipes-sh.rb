class PipesSh < Formula
  desc "Animated pipes terminal screensaver"
  homepage "https://github.com/pipeseroni/pipes.sh"
  url "https://github.com/pipeseroni/pipes.sh/archive/v1.1.0.tar.gz"
  sha256 "829f0815f0721453833942c8da28bf02845bfef9f844373d9ed67d5017a54588"
  head "https://github.com/pipeseroni/pipes.sh.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ee191fc68be98f63ef5d872815b522f8b40b285273ab965e677e735dcfc9f942" => :sierra
    sha256 "14ea3381314db998d274e1bfe636ecd8cd3629ad708d28974bed1c144a286469" => :el_capitan
    sha256 "f6c2332220663da0ba0374a88b3a9409e69742c7f967e2fd536b4ce24a49f290" => :yosemite
    sha256 "8ad12a3cbe7eb4c688c596bc1ada47be817a023b4126e60396fff559177135bc" => :mavericks
    sha256 "b48d90407346007abae552a9b8466ec716f6b0ef0547e27ee19fc364005e83d9" => :mountain_lion
  end

  depends_on "bash"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/pipes.sh -v").strip.split[-1]
  end
end

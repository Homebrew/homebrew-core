class GotPortable < Formula
  desc "Distributed version control system"
  homepage "http://gameoftrees.org"
  url "http://gameoftrees.org/releases/portable/got-portable-0.74.tar.gz"
  sha256 "5c495209d161db8adfda0a2c8d2d011be54da8b64d2d8798914cb8b7944876fe"
  license "ISC"
  head "https://git.gameoftrees.org/got-portable.git"

  depends_on "pkg-config" => :build
  depends_on "ncurses"

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "install"
  end

  test do
    ENV["GOT_AUTHOR"] = "Flan Hacker <flan_hacker@openbsd.org>"
    system bin/"gotadmin", "init", "repo.git"
    mkdir "import-dir"
    %w[haunted house].each { |f| touch testpath/"import-dir"/f }
    system bin/"got", "import", "-m", "Initial Commit", "-r", "repo.git", "import-dir"
    system bin/"got", "checkout", "repo.git", "src"
  end
end

class Got < Formula
  desc "Version control system"
  homepage "https://gameoftrees.org"
  url "https://gameoftrees.org/releases/portable/got-portable-0.75.tar.gz"
  sha256 "b35324893c9aefbd6bf49602a6c9bb9d6e20670aff3c9734fefead0205bb9cb2"
  license "ISC"

  depends_on "ncurses"
  depends_on "openssl@3"
  depends_on "ossp-uuid"

  uses_from_macos "bison" => :build

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
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

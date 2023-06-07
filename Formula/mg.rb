class Mg < Formula
  desc "Small Emacs-like editor"
  homepage "https://github.com/ibara/mg"
  url "https://github.com/ibara/mg/releases/download/mg-7.0/mg-7.0.tar.gz"
  sha256 "650dbdf9c9a72ec1922486ce07112d6181fc88a30770913d71d5c99c57fb2ac5"
  license all_of: [:public_domain, "ISC", :cannot_represent]
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "478be534a09e6185a1c0047aa893d4016401ae4a81dc0177651a3c7fd3789b78"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3052fc6f184a489918dcb2f59feae7c25e11d911e4b507e2d1a1f74dfa981a20"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "22ed7427d1bbe11394d61c776f7bd2d8aefa2669a4159e81196c8d4bb706f723"
    sha256 cellar: :any_skip_relocation, ventura:        "34106b99ddac7dd6bbd65ca44a0469613daeb25c8a2a119497acba2468a7f2cc"
    sha256 cellar: :any_skip_relocation, monterey:       "39a073c05e204261444939e0e1fbd5aed12c2bbab7a787f713a463a9f4ce6855"
    sha256 cellar: :any_skip_relocation, big_sur:        "e467c5834007598019dbe5e2fb8ebddf2c06dc153ad3af0f659ef758983125cc"
    sha256 cellar: :any_skip_relocation, catalina:       "40b95e37d6c760e37102fffb1d037b14ae12bb72b5e9313a6eaa76da4ed933cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67149965b00f9cd7a4e8c632354c958ebe2d044ee216ac74e68f57f9cdc4d391"
  end

  uses_from_macos "expect" => :test
  uses_from_macos "ncurses"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"command.exp").write <<~EOS
      set timeout -1
      spawn #{bin}/mg
      match_max 100000
      send -- "\u0018\u0003"
      expect eof
    EOS

    system "expect", "-f", "command.exp"
  end
end

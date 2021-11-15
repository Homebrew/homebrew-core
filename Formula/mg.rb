class Mg < Formula
  desc "Small Emacs-like editor"
  homepage "https://github.com/ibara/mg"
  url "https://github.com/ibara/mg/releases/download/mg-6.9/mg-6.9.tar.gz"
  sha256 "3d66079d6a9a2bfba414260f6afd5de5eb148406782772e84850b8585e901925"
  license all_of: [:public_domain, "ISC", :cannot_represent]
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "76c4323db41ed64921af7db22b0169834441cf4530943941a7d3d7beada1f2c1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c795e184150e4e26b69ee7f9a862ff93ed3b7db6cda9dbc46c6671d65ae51ef0"
    sha256 cellar: :any_skip_relocation, monterey:       "2acd868f9a96baf90e15e99048e899317125fba1700e0c6df513c6013db5bc0f"
    sha256 cellar: :any_skip_relocation, big_sur:        "de2654a08096b3d8dd824c2204b85a32986ff035e2132e28706c9cf9a3b207e0"
    sha256 cellar: :any_skip_relocation, catalina:       "e620ee1c1ec65e5713c8c477fac02f6f52fa4f1c0ab85261034c45a602a41d32"
    sha256 cellar: :any_skip_relocation, mojave:         "13c778ce17746ad6531448eb48c23b8d882d7a203dcf9dda04d3fd61d0b0a28d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd7e44ce6fb5a6940358eff10e183a5cb4708ce7c089123cf79c1b4affc45e37"
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

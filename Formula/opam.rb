class Opam < Formula
  desc "OCaml package manager"
  homepage "https://opam.ocaml.org"
  url "https://github.com/ocaml/opam/releases/download/2.1.5/opam-full-2.1.5.tar.gz"
  sha256 "15e40a75f6fa419164fb20bedd27c851146c2d576a63937cd13b317f3bc2ab93"
  license "LGPL-2.1-only"
  head "https://github.com/ocaml/opam.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ad32ed8cec817253713108f1b98637ccc3502d7e4b26a84106dd8c596f89b2e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9dad7f0a00dd2eaae5641bc8bed58c3b55345eda2a52cfece9c8d9f5d32cacfa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c1513d3610c7ee1aac381f211fc97e058344e9916ec2feef23407212bf3b99f1"
    sha256 cellar: :any_skip_relocation, ventura:        "ed5bad85e04ab442b162d45c826f5acb8a227a98483530c84dff338d0f65e455"
    sha256 cellar: :any_skip_relocation, monterey:       "6221d625de9576693822ae21bedb1fa8e20f698b28696fb515416597264c1fef"
    sha256 cellar: :any_skip_relocation, big_sur:        "35a66840754e0fc5446e1a549b84e7ad2c4e36ffceba6d35004cf717e21983d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d2125ff03e05a69b470db61e840f62b45bc34cfbeedb12c4628187fb5e25e8d"
  end

  depends_on "ocaml" => [:build, :test]
  depends_on "gpatch"

  uses_from_macos "unzip"

  def install
    ENV.deparallelize

    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "lib-ext"
    system "make"
    system "make", "install"

    bash_completion.install "src/state/shellscripts/complete.sh" => "opam"
    zsh_completion.install "src/state/shellscripts/complete.zsh" => "_opam"
  end

  def caveats
    <<~EOS
      OPAM uses ~/.opam by default for its package database, so you need to
      initialize it first by running:

      $ opam init
    EOS
  end

  test do
    system bin/"opam", "init", "--auto-setup", "--disable-sandboxing"
    system bin/"opam", "list"
  end
end

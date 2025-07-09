class Mdp < Formula
  desc "Command-line based markdown presentation tool"
  homepage "https://github.com/visit1985/mdp"
  url "https://github.com/visit1985/mdp/archive/refs/tags/1.0.17.tar.gz"
  sha256 "c6ed012bc3b94967814993b1925a579afb73c763ee183ea3af646debf4af6eb0"
  license "GPL-3.0-or-later"
  head "https://github.com/visit1985/mdp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a2ed12e4affcab641cd34e6e2325c95bae75273a166f18888c8ef1b5d1d0aeb8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "814730ae8ba3e39f85dad8cadd55affddeec4df8444cb49202069b96914e93de"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "290343295135f029fd5e443ea1812a9b3f0385fa1203ce34b8d37739a34b7487"
    sha256 cellar: :any_skip_relocation, sonoma:        "f644213df8f2e6da92a10986785748b74dfdeb5196d199b8c5d68db7d7a94eac"
    sha256 cellar: :any_skip_relocation, ventura:       "e2c20eebe479eef5dabaf11c01a8841425fa298ed8161c3136424612d157fce2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "accf91339b50263b28d1bbad33f1999263d2635ddc1301af9fe66a916dca6ca5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14b47b50fc44edb1fea8643342e1b74c57d269abd35fef7ab4aceb0b50cf1fac"
  end

  uses_from_macos "ncurses"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
    pkgshare.install "sample.md"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mdp -v")
  end
end

class Krep < Formula
  desc "High-Performance String Search Utility"
  homepage "https://github.com/davidesantangelo/krep"
  url "https://github.com/davidesantangelo/krep/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "9929a0b8a4d6502689e562657777f2ce47fc4e1d67ae81b6f1d2104ac1900b84"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d99fae9a30396e953908f6cd63619ed879d838b0a539244f507f939af4716848"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da80a539b5654fa9fa22336c74a78a637def2794ee77478db8a009a92afcf438"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c596acd523cd2d98a2cf92c75d58af3dbeb0d75c20720c4589d94a1564d903e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "253cd400937e1bc9ff303d848a41174dcd12127039ce60fce7d196db61ce56b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f8f909892abf293dcdf6dcdf0ea684b281f167980ad35cceed8d8af52fed2989"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0311b8223de6354143d8e91d395b5919b430aada13e01e46d951014618c2f98"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match version.major_minor.to_s, shell_output("#{bin}/krep -v")

    text_file = testpath/"file.txt"
    text_file.write "This should result in one match"

    output = shell_output("#{bin}/krep -c 'match' #{text_file}").strip
    assert_match "1", output
  end
end

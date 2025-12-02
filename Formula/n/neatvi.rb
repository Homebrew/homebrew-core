class Neatvi < Formula
  desc "Clone of ex/vi for editing bidirectional utf-8 text"
  homepage "https://repo.or.cz/neatvi.git"
  url "https://repo.or.cz/neatvi.git",
      tag:      "17",
      revision: "5f4a7d2f619ac808c1fa8a5d40c907032596ff55"
  license "ISC"
  head "https://repo.or.cz/neatvi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8d296ef99c8028f6e38f230b23b312dbe61e45b8f7f738da754798b5ac4b8070"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd7812e6c561174f1ed361c9c802764dcb49bf49abe937070b33303d793862de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c766536e80809b824b77c2fe995e8535b59bd84222e679307dc6f67dc305b97f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "da23ab8e6eccd2ba386f3cc1858f712b95cb2585202e4c6f3b9aa4edca7aef8e"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a264f8ba5cf2579fa3482cf661bb8e3d0551e696eeb7d1409407087e5631851"
    sha256 cellar: :any_skip_relocation, ventura:       "711cd475456f0e24dff4e631a33f3feb838faea167ab1ebd33e9268eeb64536d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a43082e969207d67c8abcd837ac737568a0e8fb4f71abe4cc4a774bdf3ae00c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8fd7720d3326d387c7a19fbcfc371c43ee80086da27327337942aebb19c6ac5e"
  end

  def install
    system "make"
    bin.install "vi" => "neatvi"
  end

  test do
    pipe_output(bin/"neatvi", ":q\n")
  end
end

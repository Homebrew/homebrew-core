class Neatvi < Formula
  desc "Clone of ex/vi for editing bidirectional utf-8 text"
  homepage "https://repo.or.cz/neatvi.git"
  url "https://repo.or.cz/neatvi.git",
      tag:      "19",
      revision: "45dafe8592090c0dfd8b29e33e6aafd0600ae19e"
  license "ISC"
  head "https://repo.or.cz/neatvi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9406bf951d0b0a979a5612007984dfa91f22d5454a5e870584ec08a471774f2e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3db63f358cf12903b9cafc397ae157e06a9061b482dcfaf8d62abb92bb6237ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ecf2f32002b0368c91203b6e591a78e6d2a2833564f3614ce2eb33a39301d962"
    sha256 cellar: :any_skip_relocation, sonoma:        "68226401e3beb02fc3a153b0da657ff845c343bf9f22eb1f19ae9e6d2a7665c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c1eba594e3c37a0d0dfe78dba342cfe5bf43c05664367539fb37093c24ecfb5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb3ab5cc3f3209cd2789e90195f6e9ebddd963bf021a1b5eae80b648e556e2d3"
  end

  def install
    system "make"
    bin.install "vi" => "neatvi"
  end

  test do
    pipe_output(bin/"neatvi", ":q\n")
  end
end

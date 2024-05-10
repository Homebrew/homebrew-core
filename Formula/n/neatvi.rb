class Neatvi < Formula
  desc "Clone of ex/vi for editing bidirectional utf-8 text"
  homepage "https://repo.or.cz/neatvi.git"
  url "https://repo.or.cz/neatvi.git",
      tag:      "15",
      revision: "d16828a4a46cbc84c30cf58c38978ad819bc0379"
  license "ISC"
  head "https://repo.or.cz/neatvi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "32d6fc1d3843b6a9a311745c1fd4b4992a2b66a65e2e5a25dc6b287f788b3073"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "50174f1ef2009aa082eb1af8dee8c19515d352a3dce3b06dfb16239d3d59ee63"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c956559a72ad8ac26ed9edf47b268eb2fdd49b2b2cb0658ff4038c328a79c93"
    sha256 cellar: :any_skip_relocation, sonoma:         "10b09148dbc99b1274ac8409e3c7eb7a042ff0ae7d017430a2e91f3d31b9b02a"
    sha256 cellar: :any_skip_relocation, ventura:        "c0046330b2a5a34e58f6427cb25706740840c0f8568fe481bf85a93091be539f"
    sha256 cellar: :any_skip_relocation, monterey:       "c72937c5db3c31caee1c08eb4ea36ca29b56a949adb91a600f4ffa9b9d106f1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed0aa6ff92a31a2ca7bcf10ad614e0d9ddc2fac74733754967880fd84237c5f1"
  end

  def install
    system "make"
    bin.install "vi" => "neatvi"
  end

  test do
    pipe_output("#{bin}/neatvi", ":q\n")
  end
end

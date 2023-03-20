class Ghq < Formula
  desc "Remote repository management made easy"
  homepage "https://github.com/x-motemen/ghq"
  url "https://github.com/x-motemen/ghq.git",
      tag:      "v1.4.1",
      revision: "17a60a90078e7de084b5d8473ee1b0e3395f9b45"
  license "MIT"
  head "https://github.com/x-motemen/ghq.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2aba0daa438f7965bc26d14c9446d877b4db04182d920d55e61727f64caaa848"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5211875ee9a0147b9e85a6e4b23e7c99f6ac9123d57b8957f5b55bae1d0df649"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c816c7db8ca9c116ad526bd84b063bb1bd31b08ff1cdd3d01534a5fde9067611"
    sha256 cellar: :any_skip_relocation, ventura:        "190fa3dd14e708c997f76fa9d497c21811c64855c76cb42f1ed9aca6d28336df"
    sha256 cellar: :any_skip_relocation, monterey:       "75cac47d922fdca3e80d4d433ec955048c4ca58d7fd964012f4cbaced58ef9f2"
    sha256 cellar: :any_skip_relocation, big_sur:        "71c161fc5532a0051c3b14229f69836f0b7b7681dbc49cfe7b0fbdf0323353a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cbfcb037c4a4c913d33c6680ac877ad0f8ec7a465a1c4c868e108b9563517b9a"
  end

  depends_on "go" => :build

  def install
    system "make", "build", "VERBOSE=1"
    bin.install "ghq"
    bash_completion.install "misc/bash/_ghq" => "ghq"
    zsh_completion.install "misc/zsh/_ghq"
  end

  test do
    assert_match "#{testpath}/ghq", shell_output("#{bin}/ghq root")
  end
end

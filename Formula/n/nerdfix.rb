class Nerdfix < Formula
  desc "Find/fix obsolete Nerd Font icons"
  homepage "https://github.com/loichyan/nerdfix"
  url "https://github.com/loichyan/nerdfix/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "e56f648db6bfa9a08d4b2adbf3862362ff66010f32c80dc076c0c674b36efd3c"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8154d59076667de95521fe0ed9ba39441627730a591c718aa0be6ed4a3d70627"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5acc95bc0c1314b40e2fb0555b97724538609e457d5574e1a5dcf61ac97942de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "248d5d912540c309ba86f239eca1016f5cac27823a9e258f07be6aef79a39ce5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "746859b3faa37328b50b548711830edec81ecf0d1a874a7902cc2161bc961438"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e2875debaaa6b165db6d0a3fbb92a9593ac4eca542dea253da61f99c1581051"
    sha256 cellar: :any_skip_relocation, ventura:       "cc197b42aa7b59787c5a1cda9471bcc7ed1ec01557bc36500acb46ee3170fca8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fbd2787883392023478e8725c0fc6a0181e359c390698090eafcd2a038a3358d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c92886e7e4886f45c9d8f21a31389aff08e62bdf5b5bfda780b4e174c64f3656"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"nerdfix", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nerdfix --version")

    touch "test.txt"
    system bin/"nerdfix", "check", "test.txt"
  end
end

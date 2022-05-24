class Fnm < Formula
  desc "Fast and simple Node.js version manager"
  homepage "https://github.com/Schniz/fnm"
  url "https://github.com/Schniz/fnm/archive/v1.31.0.tar.gz"
  sha256 "c501220d8469f0082c0813d172171f1a19e4d2c4999573bf51a23094773e7041"
  license "GPL-3.0-only"
  head "https://github.com/Schniz/fnm.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d4baa49d521ed7121125f96ad0ea31edf6cdee772af0ab7481350fb5a23fcbb0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "32ed39e829779bc5fb172b5b69a972fb358a7a30a571723efd593fdb957acffc"
    sha256 cellar: :any_skip_relocation, monterey:       "de56a828f1fe5c66f3960e7314029bfe6efa06db0c94e2b30b2549a62d20cc07"
    sha256 cellar: :any_skip_relocation, big_sur:        "8b0e69c49e72a15560eef4dca34ff6d61a18b64617b6ea5850a0a6d98c9a8db2"
    sha256 cellar: :any_skip_relocation, catalina:       "12df0791e22dc4674056e6333e2a1c18d75eb7af796ce9657d462324611674fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1a69182a0a061aea437f9ffae2e5d40b8d92eebe318fadb7a5f3b6d7a571602"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args

    (bash_completion/"fnm").write Utils.safe_popen_read(bin/"fnm", "completions", "--shell=bash")
    (fish_completion/"fnm.fish").write Utils.safe_popen_read(bin/"fnm", "completions", "--shell=fish")
    (zsh_completion/"_fnm").write Utils.safe_popen_read(bin/"fnm", "completions", "--shell=zsh")
  end

  test do
    system bin/"fnm", "install", "12.0.0"
    assert_match "v12.0.0", shell_output("#{bin}/fnm exec --using=12.0.0 -- node --version")
  end
end

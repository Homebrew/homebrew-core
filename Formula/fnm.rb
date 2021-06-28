class Fnm < Formula
  desc "Fast and simple Node.js version manager"
  homepage "https://fnm.vercel.app"
  url "https://github.com/Schniz/fnm/archive/v1.25.0.tar.gz"
  sha256 "c1ea037eea02dcea1f05b8a6fa7b8b612d52b3fabbac22f197d15ece51267396"
  license "GPL-3.0-only"
  head "https://github.com/Schniz/fnm.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f452f231a5d8c6f3c4795c7cedb1c1069e2c087d71033922e0d0feadbdfab5c7"
    sha256 cellar: :any_skip_relocation, big_sur:       "1aceb43c8d1cd23b37ef3e5cb39958a3723021b4aa8796226ae5452cdb1648c3"
    sha256 cellar: :any_skip_relocation, catalina:      "22f971bf095b1c786fc3ac5cd51ed772348cecb518abfd14c14890508418057e"
    sha256 cellar: :any_skip_relocation, mojave:        "b809a52a73726c35e08d89076123f9dd3978615e229d88bc41257fd3bb434b0b"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args

    (bash_completion/"fnm").write Utils.safe_popen_read("#{bin}/fnm", "completions", "--shell=bash")
    (fish_completion/"fnm.fish").write Utils.safe_popen_read("#{bin}/fnm", "completions", "--shell=fish")
    (zsh_completion/"_fnm").write Utils.safe_popen_read("#{bin}/fnm", "completions", "--shell=zsh")
  end

  test do
    system("#{bin}/fnm", "install", "12.0.0")
    assert_match "v12.0.0", shell_output("#{bin}/fnm exec --using=12.0.0 -- node --version")
  end
end

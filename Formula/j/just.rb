class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/refs/tags/1.25.1.tar.gz"
  sha256 "52a77acb3b8ee109a3a3a6dc5f25cad9418cdd009438788098128d737cc537d2"
  license "CC0-1.0"
  head "https://github.com/casey/just.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8f7eb09958671144a20c969f260a2befce2a86a39023e8fba68ba8ba9930f160"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4628a550447bbb76d10a6674bb6af1d08746c57cbd2fad3015fbaf9ce88a138e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "90a02036be365bc6e09135a7853fa949528b4e2605e3df07018f8f8224efe5ea"
    sha256 cellar: :any_skip_relocation, sonoma:         "06a3408cb2b1162a405c04fa033b4ce7c96f290dfd01a8b149c295ef37feac44"
    sha256 cellar: :any_skip_relocation, ventura:        "285375c0c6cee5723f35ad05b70eba1baa183720b17c907fe6df3a5babe052d7"
    sha256 cellar: :any_skip_relocation, monterey:       "2e8aa47e5a3b962cae48928ae49977b85ad28398339192c60a483bf87186cb91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5090a887ae4df8c91b5473ca35fc46af30bef1d5e70d5f95ecb50d3cb69cfcea"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    man1.install "man/just.1"
    bash_completion.install "completions/just.bash" => "just"
    fish_completion.install "completions/just.fish"
    zsh_completion.install "completions/just.zsh" => "_just"
  end

  test do
    (testpath/"justfile").write <<~EOS
      default:
        touch it-worked
    EOS
    system bin/"just"
    assert_predicate testpath/"it-worked", :exist?
  end
end

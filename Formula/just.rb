class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/v0.9.2.tar.gz"
  sha256 "0f064d0ea9f3d8bbcd84c5e6a85243738bdb6f49d059f589fd6928c64ea6fb64"
  license "CC0-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9a6066f3e876dadad0244ca4eb12bbb4ba9b7bb429654b924fea6f160aad2c01"
    sha256 cellar: :any_skip_relocation, big_sur:       "f4a4a31140659652e4f4a1ea0432472cb0bba15704203664b0fe51f3b61d7b51"
    sha256 cellar: :any_skip_relocation, catalina:      "85bc7713b3f81385b0eb780a1703eda10e1a7301e03a419668fcb3df4b118998"
    sha256 cellar: :any_skip_relocation, mojave:        "973063cd086b1312a06d77d4ee38e5f3eb1e0d5a5bfc37744b0a9d1bd005da58"
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
    system "#{bin}/just"
    assert_predicate testpath/"it-worked", :exist?
  end
end
